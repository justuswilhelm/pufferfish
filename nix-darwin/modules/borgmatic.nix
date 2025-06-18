# TODO investigate how to use APFS snapshotting
# volume=$(tmutil localsnapshot | grep -o -E '\d{4}-\d{2}-\d{2}-\d{6}')
# dest=$(mktemp -d)
# mount_apfs -o ro -s "com.apple.TimeMachine.$volume.local" /Volumes "$dest"
{ pkgs, config, lib, ... }:
let
  borgmatic = pkgs.borgmatic;
  statePath = "/var/lib/borgmatic";
  logPath = "/var/log/borgmatic";

  send_nsca = config.services.nagios.nsca.send_shortcut "lithium.local" "borgmatic";

  borgmaticConfig = {
    source_directories = [
      "/etc"
      "/Applications"
      "/Library"
      "/Users"
      "/var"
    ];
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
    after_actions = [
      (send_nsca 0 "{repository} OK")
    ];
    on_error = [
      (send_nsca 2 "{repository} ERROR {error}: {output}")
    ];
    # Migrate to something like this when we have borgmatic v2
    # https://torsion.org/borgmatic/docs/how-to/add-preparation-and-cleanup-steps-to-backups/
    # commands = [
    #   {
    #     after = "action";
    #     run = [
    #       CMD here
    #     ];
    #   }
    #   {
    #     after = "error";
    #     states = ["fail"];
    #     run = [
    #       CMD here
    #     ];
    #   }
    # ];
  };

  borgmaticConfigYaml =
    let
      yamlFormat = pkgs.formats.yaml { };
      cfg = yamlFormat.generate "borgmatic_base.yaml" borgmaticConfig;
      validated = pkgs.runCommand "borgmatic_base_checked.yml" { preferLocalBuild = true; } ''
        cp ${cfg} borgmatic_base.yml
        ${borgmatic}/bin/borgmatic config validate \
          --config borgmatic_base.yml && cp ${cfg} $out

      '';
    in
    validated;

  # Let borgmatic run for 50 min max
  timeout = 60 * 50;
  # Kill after not responding to SIGINT
  killAfter = 2 * 60;
in
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
            check_command check_dummy!2 "Haven't heard from orgmatic in a while "
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
      chmod -R go= ${statePath}
    '';
  };

}
