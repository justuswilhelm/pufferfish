{ config, pkgs, lib, ... }:
let
  offlineimap = "${pkgs.offlineimap}/bin/offlineimap";
  logPath = "/Users/${config.system.primaryUser}/Library/Logs/offlineimap/offlineimap.log";
  timeout = 3 * 60;
  # Kill after not responding to SIGINT
  killAfter = 2 * 60;
  send_nsca = "${config.services.nagios.nsca-package}/bin/send_nsca";
  # TODO pull this value in from nsca config nix
  nsca_config = "/etc/nagios/send_nsca.conf";
  nsca_host = "127.0.0.1";
  nsca_port = toString 5667;
in
{
  environment.systemPackages = [ pkgs.offlineimap ];

  services.newsyslog.modules.offlineimap = {
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
      cfg = pkgs.writeText "offlineimap.cfg" ''
        define service {
            use generic-service
            host_name lithium.local
            service_description offlineimap
            active_checks_enabled 0
            display_name OfflineIMAP
            freshness_threshold 86400  ; 24 hours
            check_freshness 1
            check_command check_dummy!2 "Haven't heard from offlineimap in a while "
        }
      '';
    in
    lib.optional config.services.nagios.enable cfg;

  launchd.user.agents = {
    "offlineimap" = {
      path = [ pkgs.coreutils pkgs.moreutils ];
      script = ''
        (
          if ! /sbin/ping -q -c 1 example.com
          then
            echo "Looks like we're offline"
            exit 0
          fi
          # Kill after 120 seconds of not reacting
          if timeout --kill-after=${toString killAfter}s --signal=INT ${toString timeout}s ${offlineimap}
          then
            echo -e 'lithium.local,offlineimap,0,success' | ${send_nsca} ${nsca_host} -p ${nsca_port} -c ${nsca_config} -d ,
          else
            echo -e 'lithium.local,offlineimap,2,fail' | ${send_nsca} ${nsca_host} -p ${nsca_port} -c ${nsca_config} -d ,
          fi
        ) 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
      '';
      serviceConfig = {
        # Performance
        ProcessType = "Background";
        LowPriorityBackgroundIO = true;
        LowPriorityIO = true;
        # We log everything, in case timeout or send_nsca encounter errors
        # 2>&1 into ts combines all logs into stdout
        StandardOutPath = logPath;
        # Every 5 minutes
        StartInterval = 5 * 60;
      };
    };
  };
}
