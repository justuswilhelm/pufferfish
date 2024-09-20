{ config, pkgs, ... }:
let
  logPath = "/var/log/borgmatic/borgmatic.log";
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

  launchd.daemons.borgmatic = {
    command = "${borgmatic}/bin/borgmatic --log-file-verbosity 2 --log-file ${logPath}";
    serviceConfig = {
      # Performance
      ProcessType = "Background";
      LowPriorityBackgroundIO = true;
      LowPriorityIO = true;
      TimeOut = 1800;

      # Timing
      StartCalendarInterval = [{ Minute = 0; }];
    };
  };
}
