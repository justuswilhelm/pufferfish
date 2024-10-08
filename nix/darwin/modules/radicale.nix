{ config, pkgs, ... }:
let
  storage-filesystem-folder = "/var/local/radicale/collections";
  logPath = "/var/local/log/radicale";

  radicale = pkgs.radicale;
in
{
  users.groups.radicale = { gid = 1020; };
  users.users.radicale = {
    description = "Radicale User";
    gid = 1020;
    uid = 1020;
    isHidden = true;
  };
  environment.etc."radicale/config".source = ./radicale.ini;
  users.knownGroups = [ "radicale" ];
  users.knownUsers = [ "radicale" ];
  environment.systemPackages = [ radicale ];
  launchd.daemons.radicale = {
    command = "${radicale}/bin/radicale";
    serviceConfig = {
      KeepAlive = true;
      StandardOutPath = "${logPath}/radicale.stdout.log";
      StandardErrorPath = "${logPath}/radicale.stderr.log";
      UserName = "radicale";
      GroupName = "radicale";
    };
  };
}
