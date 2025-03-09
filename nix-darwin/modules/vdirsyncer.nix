{ config, specialArgs, pkgs, ... }:
let
  vdirsyncer = pkgs.vdirsyncer;
  logPath = "/Users/${specialArgs.name}/Library/Logs/offlineimap";
in
{
  environment.systemPackages = [
    pkgs.vdirsyncer
  ];
  launchd.user.agents.vdirsyncer = {
    path = [ pkgs.coreutils vdirsyncer ];
    command = "vdirsyncer sync";
    serviceConfig = {
      # Performance
      ProcessType = "Background";
      LowPriorityBackgroundIO = true;
      LowPriorityIO = true;
      # Every 5 minutes
      StartInterval = 5 * 60;
      # Time out after 3 minutes
      TimeOut = 5 * 60;
      StandardOutPath = "${logPath}/vdirsyncer.stdout.log";
      StandardErrorPath = "${logPath}/vdirsyncer.stderr.log";
    };
  };
}
