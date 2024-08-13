{ config, pkgs, ... }:
let
  logPath = "/var/log/borgmatic";
  borgmatic = pkgs.borgmatic;
in
{
  environment.systemPackages = [
    borgmatic
  ];
  environment.etc = {
    borgmatic_base = {
      source = ./borgmatic_base.yaml;
      target = "borgmatic/base/borgmatic_base.yaml";
    };
  };

  launchd.agents = {
    "borgmatic" = {
      command = "${borgmatic}/bin/borgmatic --log-file-verbosity 1 --log-file /dev/stdout";
      serviceConfig = {
        # Performance
        ProcessType = "Background";
        LowPriorityBackgroundIO = true;
        LowPriorityIO = true;
        TimeOut = 1800;

        # Logging
        StandardOutPath = "${logPath}/borgmatic.log";

        # Timing
        StartCalendarInterval = [
          {
            Minute = 0;
          }
        ];
      };
    };
  };
}
