{ config, pkgs, ... }:
let
  user = "delighted-negotiate-catchy";
in
{
  # Blank slate user to ensure we don't pass PID
  users.groups.${user} = {
    gid = 604;
  };
  users.knownGroups = [ user ];
  users.users.${user} = {
    description = "random user for pentesting";
    gid = 604;
    uid = 520;
    isHidden = true;
    home = "/tmp/${user}";
    shell = pkgs.fish;
  };
  users.knownUsers = [ user ];
}
