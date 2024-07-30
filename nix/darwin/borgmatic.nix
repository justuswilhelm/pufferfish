{ config, pkgs, ... }:
let
  borgmatic = pkgs.borgmatic;
  name = "justusperlwitz";
  home = "/Users/${name}";
  library = "${home}/Library";
  logPath = "${library}/Logs/borgmatic";
in
{
  environment.systemPackages = [
    borgmatic
  ];

  launchd.user.agents = {
    # TODO
    # Could this be a systemwide launchd.agents.borgmatic instead?
    "borgmatic" = {
      serviceConfig = {
        ProgramArguments = [
          "${borgmatic}/bin/borgmatic"
          "--log-file-verbosity"
          "1"
          "--log-file"
          "/dev/stdout"
        ];
        StandardOutPath = "${logPath}/borgmatic.log";
        StartCalendarInterval = [
          {
            Minute = 0;
          }
        ];
        TimeOut = 1800;
      };
    };
  };
}
