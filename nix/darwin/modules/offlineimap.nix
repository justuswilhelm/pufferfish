{ config, pkgs, ... }:
let
  offlineimap = pkgs.offlineimap;
  name = "justusperlwitz";
  home = "/Users/${name}";
  library = "${home}/Library";
  logPath = "${library}/Logs/offlineimap";
in
{
  launchd.user.agents = {
    "offlineimap" = {
      path = [ offlineimap config.services.nagios.nsca-package ];
      script = ''
        if offlineimap -l '${logPath}/offlineimap.log'; then
          echo -e 'lithium.local,offlineimap,0,success' | send_nsca 127.0.0.1 -p 5667 -c /etc/nagios/send_nsca.conf -d ,
        else
          echo -e 'lithium.local,offlineimap,2,fail' | send_nsca 127.0.0.1 -p 5667 -c /etc/nagios/send_nsca.conf -d ,
        fi
      '';
      serviceConfig = {
        # Performance
        ProcessType = "Background";
        LowPriorityBackgroundIO = true;
        LowPriorityIO = true;
        # Every 5 minutes
        StartInterval = 5 * 60;
        # Time out after 3 minutes
        TimeOut = 3 * 60;
      };
    };
  };
}
