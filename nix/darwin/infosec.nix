{ config, pkgs, ... }:
{
  # A not very privileged user
  users.groups.delighted-negotiate-catchy = {
    gid = 604;
  };
  users.users.delighted-negotiate-catchy = {
    createHome = false;
    description = "random user for pentesting";
    gid = 604;
    uid = 54;
    isHidden = true;
  };
  users.knownUsers = [
    "delighted-negotiate-catchy"
  ];
  users.knownGroups = [
    "delighted-negotiate-catchy"
  ];
}
