{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vdirsyncer;
  vdirsyncer = pkgs.vdirsyncer;
  logPath = "/Users/${config.system.primaryUser}/Library/Logs/vdirsyncer/vdirsyncer.log";
  timeout = 3 * 60;
  # Kill after not responding to SIGINT
  killAfter = 2 * 60;
  send_nsca = config.services.nagios.nsca.send_shortcut "lithium.local" "vdirsyncer";
in
{
  options.services.vdirsyncer = {
    enable = mkEnableOption "Enable vdirsyncer";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.vdirsyncer
    ];

    services.newsyslog.modules.vdirsyncer = {
      ${logPath} = {
        owner = config.system.primaryUser;
        mode = "600";
        count = 10;
        when = "$D0";
        flags = "J";
      };
    };

    services.nagios.objectDefs =
      let
        # https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/freshness.html
        nagiosCfg = pkgs.writeText "vdirsyncer.cfg" ''
          define service {
              use generic-service
              host_name lithium.local
              service_description vdirsyncer
              active_checks_enabled 0
              display_name vdirsyncer
              freshness_threshold 86400  ; 24 hours
              check_freshness 1
              check_command check_dummy!2 "Haven't heard from vdirsyncer in a while "
          }
        '';
      in
      lib.optional config.services.nagios.enable nagiosCfg;

    launchd.user.agents.vdirsyncer = {
      path = [ pkgs.coreutils pkgs.moreutils vdirsyncer ];
      script = ''
        (
          if ! /sbin/ping -q -c 1 example.com > /dev/null
          then
            echo "Looks like we're offline"
            exit 0
          fi
          if timeout --kill-after=${toString killAfter}s --signal=INT ${toString timeout}s vdirsyncer sync
          then
            ${send_nsca 0 "vdirsyncer OK"}
          else
            ${send_nsca 2 "vdirsyncer failed"}
          fi
        ) 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
      '';
      serviceConfig = {
        # Performance
        ProcessType = "Background";
        LowPriorityBackgroundIO = true;
        LowPriorityIO = true;
        # Every 5 minutes
        StartInterval = 5 * 60;
        # Combining everything to stdout
        StandardOutPath = logPath;
      };
    };
  };
}
