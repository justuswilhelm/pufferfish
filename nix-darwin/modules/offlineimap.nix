{ config, specialArgs, pkgs, ... }:
let
  offlineimap = "${pkgs.offlineimap}/bin/offlineimap";
  logPath = "/Users/${specialArgs.name}/Library/Logs/offlineimap/offlineimap.log";
  timeout = 3 * 60;
  send_nsca = "${config.services.nagios.nsca-package}/bin/send_nsca";
  # TODO pull this value in from nsca config nix
  nsca_config = "/etc/nagios/send_nsca.conf";
  nsca_host = "127.0.0.1";
  nsca_port = toString 5667;
in
{
  # Copied from /etc/newsyslog.d/wifi.conf
  environment.etc."newsyslog.d/borgmatic.conf".text = ''
    # logfilename            [owner:group]        mode count size when  flags [/pid_file] [sig_num]
    ${logPath}               ${specialArgs.name}  600  10    *    $D0   J
  '';

  launchd.user.agents = {
    "offlineimap" = {
      script = ''
        if timeout --signal INT ${toString timeout} ${offlineimap} -l ${logPath}
        then
          echo -e 'lithium.local,offlineimap,0,success' | ${send_nsca} ${nsca_host} -p ${nsca_port} -c ${nsca_config} -d ,
        else
          echo -e 'lithium.local,offlineimap,2,fail' | ${send_nsca} ${nsca_host} -p ${nsca_port} -c ${nsca_config} -d ,
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
