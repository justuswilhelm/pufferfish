{ pkgs, config, lib, ... }:
let
  borgmatic = pkgs.borgmatic;
  statePath = "/var/lib/borgmatic";
  logPath = "/var/log/borgmatic";

  send_nsca = config.services.nagios.nsca.send_shortcut "lithium.local" "borgmatic";

  makeSnapshot = pkgs.writeShellApplication {
    name = "make-snapshot";
    runtimeInputs = [ pkgs.gnugrep ];
    text = ''
      set -o pipefail
      volume=$(/usr/bin/tmutil localsnapshot | grep -o -E "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{6}")
      /sbin/mount_apfs -o ro -s "com.apple.TimeMachine.$volume.local" /Volumes "${statePath}/snapshot"
    '';
  };

  unmountSnapshot = pkgs.writeShellApplication {
    name = "unmount-snapshot";
    text = ''
      /sbin/umount "${statePath}/snapshot"
    '';
  };

  borgmaticConfig = {
    source_directories = [
      "private/etc"
      "Applications"
      "Library"
      "Users"
      "private/var"
    ];
    # Prevent borgmatic from silently not updating one of the above directories
    source_directories_must_exist = true;
    working_directory = "${statePath}/snapshot";
    exclude_patterns = [
      "/Library/Developer"
      "/Library/Updates"
      "/Library/Caches/*"
      "/Users/*/.Trash"
      "/Users/*/.cache"
      "/Users/*/Library/Caches"
      "/Users/*/Library/Developer/CoreSimulator/Caches/*"
      "/Users/*/Library/Biome/*"
      "/Users/*/Library/Metadata/CoreSpotlight/*"
      "/Users/*/Movies"
    ];
    encryption_passcommand = "${pkgs.coreutils}/bin/cat ${statePath}/passphrase";
    ssh_command = "ssh -o 'UserKnownHostsFile=${statePath}/ssh/known_hosts' -i${statePath}/ssh/id_rsa";
    borg_base_directory = statePath;
    borg_config_directory = "${statePath}/config";
    borg_cache_directory = "${statePath}/cache";
    borg_security_directory = "${statePath}/security";

    keep_hourly = 6;
    keep_daily = 7;
    keep_weekly = 4;
    keep_monthly = 6;
    keep_yearly = 1;
    repositories = [ ];

    checks = [
      { name = "repository"; frequency = "1 month"; }
      { name = "archives"; frequency = "1 month"; }
    ];
    check_last = 10;
    # TODO add individual per-repository checks
    # https://torsion.org/borgmatic/docs/how-to/add-preparation-and-cleanup-steps-to-backups/
    commands = [
      {
        before = "configuration";
        when = [ "create" ];
        run = [ "${makeSnapshot}/bin/make-snapshot" ];
      }
      {
        after = "configuration";
        when = [ "create" ];
        run = [ "${unmountSnapshot}/bin/unmount-snapshot" ];
      }
      {
        after = "action";
        when = [ "create" ];
        states = [ "finish" ];
        run = [
          (send_nsca 0 "{repository} OK")
        ];
      }
      {
        after = "error";
        # Send all errors to Nagios
        # when = [ "create" ];
        run = [
          (send_nsca 2 "{repository} ERROR {error}: {output}")
        ];
      }
    ];
  };

  borgmaticConfigYaml =
    let
      yamlFormat = pkgs.formats.yaml { };
      cfg = yamlFormat.generate "borgmatic_base.yaml" borgmaticConfig;
    in
    pkgs.runCommand "borgmatic_base_checked.yml" { preferLocalBuild = true; } ''
      cp ${cfg} borgmatic_base.yml
      ${borgmatic}/bin/borgmatic config validate \
        --config borgmatic_base.yml && cp ${cfg} $out
    '';

  # Let borgmatic run for 50 min max
  timeout = 60 * 50;
  # Kill after not responding to SIGINT
  killAfter = 2 * 60;
in
with lib;
{
  options.services.borgmatic = {
    enable = mkEnableOption "borgmatic backup service";
  };

  config = mkIf config.services.borgmatic.enable
    {
      environment.systemPackages = [ borgmatic ];

      environment.etc."borgmatic/base/borgmatic_base.yaml".source = borgmaticConfigYaml;

      services.newsyslog.modules.borgmatic = {
        "${logPath}/borgmatic.stdout.log" = {
          mode = "640";
          count = 10;
          size = "*";
          when = "$D0";
          flags = "J";
        };
      };

      services.nagios.objectDefs =
        let
          # https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/freshness.html
          cfg = pkgs.writeText "borgmatic.cfg" ''
            define service {
                use generic-service
                host_name lithium.local
                service_description borgmatic
                active_checks_enabled 0
                display_name Borgmatic
                freshness_threshold 86400  ; 24 hours
                check_freshness 1
                check_command check_dummy!2 "Haven't heard from borgmatic in a while "
            }
          '';
        in
        lib.optional config.services.nagios.enable cfg;

      launchd.daemons.borgmatic = {
        path = [ borgmatic pkgs.moreutils pkgs.coreutils ];
        script = ''
          timeout --kill-after=${toString killAfter}s \
            --signal INT ${toString timeout}s \
          /usr/bin/caffeinate -s \
          borgmatic \
            --verbosity 2 \
            2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
        '';
        serviceConfig = {
          # Performance
          ProcessType = "Background";
          LowPriorityBackgroundIO = true;
          # Borgmatic's syslog doesn't appear to work on macOS.
          # We might be missing out on some error messages
          # All logged to stdout now using `ts`
          StandardOutPath = "${logPath}/borgmatic.stdout.log";
          # Maybe:
          # NetworkState = true;
          # So that we don't try to back up when not connected to the network
          LowPriorityIO = true;
          # Timing
          StartCalendarInterval = [{ Minute = 0; }];
        };
      };

      system.activationScripts.preActivation = {
        text = ''
          mkdir -p ${logPath} ${statePath}
          chmod go= ${statePath}
        '';
      };
    };
}
