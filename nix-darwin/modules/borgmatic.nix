{ pkgs, config, lib, ... }:
let
  borgmatic = pkgs.borgmatic;
  statePath = "/private/var/lib/borgmatic";
  snapshotPath = "${statePath}/snapshot";
  logPath = "/private/var/log/borgmatic/borgmatic.log";

  makeSnapshot = pkgs.writeShellApplication {
    name = "make-snapshot";
    runtimeInputs = [ pkgs.gnugrep unmountSnapshot ];
    # Attempts to unmount of it finds a mounted snapshot. Gives up when it
    # can't unmoiunt it
    text = ''
      set -o pipefail
      if [ -e "$1" ] && [ ! -d "$1" ]; then
        echo "File at $1 already exists but is not a directory"
        exit 1
      fi
      if [ ! -e "$1" ]; then
        echo "Creating directory for mount point at $1"
        mkdir "$1"
      fi
      if already_mounted=$(/sbin/mount | grep "$1"); then
        echo "Already mounted a snapshot at $1:"
        echo "$already_mounted"
        echo
        echo "Trying to unmount $1"
        if ! unmount-snapshot "$1"; then
          echo "Could not unmount snapshot, exiting"
          exit 1
        fi
      fi
      if ! volume=$(/usr/bin/tmutil localsnapshot | tee /dev/stderr | grep -o -E "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{6}"); then
        echo "Error when creating snapshot"
        exit 1
      fi
      echo "Snapshot at $volume"
      if ! /sbin/mount_apfs -o ro -s "com.apple.TimeMachine.$volume.local" /Volumes "$1"; then
        echo "Error when mounting snapshot"
        exit 1
      fi
    '';
  };

  unmountSnapshot = pkgs.writeShellApplication {
    name = "unmount-snapshot";
    runtimeInputs = [ pkgs.gnugrep ];
    # Try both umount and diskutil umount here because
    # umount can fail
    # umount(/private/var/lib/borgmatic/snapshot): Resource busy -- try 'diskutil unmount'
    text = ''
      if [ ! -d "$1" ]; then
        echo "Error: $1 is not a directory"
        exit 1
      fi
      if ! /sbin/mount | grep "$1"; then
        echo "$1 is not mounted, nothing to do"
        exit 0
      fi

      if /usr/sbin/diskutil umount force "$1"; then
        echo "Unmounted $1 with /usr/sbin/diskutil"
      else
        echo "Couldn't unmount $1 with /usr/sbin/diskutil, status $?"

        if /sbin/umount "$1"; then
          echo "Unmounted $1 with /sbin/umount"
        else
          echo "Couldn't unmount $1 with /sbin/umount, status $?"
          exit 1
        fi
      fi

      if still_mounted=$(/sbin/mount | grep "$1"); then
        echo "$1 is still mounted:"
        echo "$still_mounted"
        exit 1
      fi
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
    # source_directories_must_exist = true;
    exclude_patterns = [
      "Library/Developer"
      "Library/Updates"
      "*/.Trash"

      # Caches
      "Library/Caches"
      "*/Library/Caches"
      "*/.cache"

      # TODO think about excluding these:
      # "Users/*/Librrary/Group Containers/group.com.apple*"
      # "Users/*/Librrary/Containers/com.apple*"

      # Temp
      "private/var/tmp"
      "/tmp"
      "private/var/folders"

      # These programs should have been using a XDG cache
      # directory:
      "Users/*/.npm"
      "Users/*/.cargo"
      "Users/*/.rustup"
      "Users/*/.rzup"
      "*/node_modules"

      # No need to commit these
      "Users/*/.config/nvim/plugged"

      # Something for handoff? Don't need this
      "Users/*/Library/DuetExpertCenter"

      # Other Apple stuff
      "Users/*/Library/Developer/CoreSimulator"
      "Users/*/Library/Biome"
      "Users/*/Library/Metadata/CoreSpotlight"
      "Library/Logs/CrashReporter/CoreCapture"
      "Users/*/Library/Weather"

      # Apple stuff with high mod frequencies
      "private/var/db/diagnostics/Special"
      "private/var/db/accessoryupdater/uarp/tmpfiles"
      "private/var/protected/sfanalytics"
      "private/var/db/Spotlight-V100"
      "private/var/db/uuidtext"

      # Little snitch
      "Library/Application Support/Objective Development/Little Snitch/TrafficLog"

      # Too big
      "Users/*/Movies"
    ];
    exclude_caches = true;

    encryption_passcommand = "${pkgs.coreutils}/bin/cat ${statePath}/passphrase";

    checkpoint_interval = 60 * 15;

    ssh_command = "ssh -o 'UserKnownHostsFile=${statePath}/ssh/known_hosts' -i${statePath}/ssh/id_rsa";
    borg_base_directory = statePath;
    borg_config_directory = "${statePath}/config";
    borg_cache_directory = "${statePath}/cache";
    borg_security_directory = "${statePath}/security";

    working_directory = snapshotPath;

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

    # Get more info on why some backups are slow
    verbosity = 2;
    statistics = true;
    list_details = true;

    # TODO add individual per-repository checks
    # https://torsion.org/borgmatic/docs/how-to/add-preparation-and-cleanup-steps-to-backups/
    commands = [
      {
        before = "configuration";
        when = [ "create" ];
        run = [ "${makeSnapshot}/bin/make-snapshot ${snapshotPath}" ];
      }
      {
        after = "configuration";
        when = [ "create" ];
        run = [ "${unmountSnapshot}/bin/unmount-snapshot ${snapshotPath}" ];
      }
      {
        after = "action";
        when = [ "create" ];
        states = [ "finish" ];
        run = [
          (config.services.nagios.nsca.send_shortcut "lithium.local" "borgmatic.{repository_label}" 0 "{repository} OK")
        ];
      }
      {
        after = "error";
        # Send all errors to Nagios
        # when = [ "create" ];
        run = [
          (config.services.nagios.nsca.send_shortcut "lithium.local" "borgmatic.{repository_label}" 2 "{repository} ERROR {error}: {output}")
        ];
      }
    ];
  };

  borgmaticHeliumConfig =
    let
      hostName = "helium";
      host = "${hostName}.local";
      remoteUser = "${config.networking.hostName}-borgbackup";
    in
    lib.attrsets.recursiveUpdate borgmaticConfig {
      repositories = [
        {
          path = "ssh://${remoteUser}@${host}/srv/borgbackup/${config.networking.hostName}";
          label = hostName;
        }
      ];
      commands = borgmaticConfig.commands ++ [
        {
          before = "action";
          run = [ "/sbin/ping -q -c 1 ${host} > /dev/null || exit 75" ];
        }
      ];
    };

  makeYaml = config:
    let
      yamlFormat = pkgs.formats.yaml { };
      cfg = yamlFormat.generate "config.yaml" config;
    in
    pkgs.runCommand "config_checked.yml" { preferLocalBuild = true; } ''
      cp ${cfg} config.yml
      ${borgmatic}/bin/borgmatic config validate \
        --config config.yml && cp ${cfg} $out
    '';

  # Let borgmatic run for 2h max
  timeout = 60 * 60 * 2;
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
      environment.systemPackages = [ borgmatic unmountSnapshot ];

      environment.etc."borgmatic/base/borgmatic_base.yaml".source = makeYaml borgmaticConfig;
      environment.etc."borgmatic.d/helium.yaml".source = makeYaml borgmaticHeliumConfig;

      services.newsyslog.modules.borgmatic = {
        ${logPath} = {
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
              name generic-borgmatic

              use generic-service
              active_checks_enabled 0
              freshness_threshold 86400  ; 24 hours
              check_freshness 1
              check_command check_dummy!2 "Haven't heard from this borgmatic backup in a while "

              register 0 ; this is a template
            }
            define service {
              use generic-borgmatic
              host_name lithium.local
              service_description borgmatic.helium
              display_name Borgmatic on Helium
            }
            define service {
              use generic-borgmatic
              host_name lithium.local
              service_description borgmatic.borgbase
              display_name Borgmatic on BorgBase
            }
          '';
        in
        lib.optional config.services.nagios.enable cfg;

      launchd.daemons.borgmatic = {
        path = [ borgmatic pkgs.moreutils pkgs.coreutils ];
        script = ''
          timeout --kill-after=${toString killAfter}s \
            --signal INT ${toString timeout}s \
            /usr/bin/caffeinate -s borgmatic 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
        '';
        serviceConfig = {
          # Performance
          ProcessType = "Background";
          LowPriorityBackgroundIO = true;
          # Borgmatic's syslog doesn't appear to work on macOS.
          # We might be missing out on some error messages
          # All logged to stdout now using `ts`
          StandardOutPath = logPath;
          WorkingDirectory = statePath;
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
          mkdir -p "$(dirname ${logPath})" ${statePath}
          chmod go= ${statePath}

          # Validate borgbase.yaml, which we don't version control
          ${borgmatic}/bin/borgmatic config validate --config /etc/borgmatic.d/borgbase.yaml
        '';
      };
    };
}
