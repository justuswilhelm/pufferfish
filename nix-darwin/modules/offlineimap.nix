{ config, specialArgs, pkgs, ... }:
let
  offlineimap = pkgs.offlineimap;
  logPath = "/Users/${specialArgs.name}/Library/Logs/offlineimap";
  timeout = 3 * 60;
  nsca = config.services.nagios.nsca-package;
in
{
  launchd.user.agents = {
    "offlineimap" = {
      script = ''
        if timeout --signal INT ${toString timeout} ${offlineimap}/bin/offlineimap -l ${logPath}/offlineimap.log
        then
          echo -e 'lithium.local,offlineimap,0,success' | ${nsca}/bin/send_nsca 127.0.0.1 -p 5667 -c /etc/nagios/send_nsca.conf -d ,
        else
          echo -e 'lithium.local,offlineimap,2,fail' | ${nsca}/bin/send_nsca 127.0.0.1 -p 5667 -c /etc/nagios/send_nsca.conf -d ,
        fi
      '';
      serviceConfig = {
        # Performance
        ProcessType = "Background";
        LowPriorityBackgroundIO = true;
        LowPriorityIO = true;
        # Every 5 minutes
        StartInterval = 5 * 60;
      };
    };
  };
}
