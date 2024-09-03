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
      serviceConfig = {
        ProgramArguments = [
          "${offlineimap}/bin/offlineimap"
          "-l"
          "/dev/stdout"
        ];
        StandardOutPath = "${logPath}/offlineimap.log";
        # Every 5 minutes
        StartInterval = 5 * 60;
        # Time out after 3 minutes
        TimeOut = 3 * 60;
      };
    };
  };
}
