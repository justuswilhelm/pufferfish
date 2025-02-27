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

  # https://unix.stackexchange.com/a/585339
  environment.etc.smbConf = {
    text = ''
      client min protocol = CORE
      client max protocol = SMB3
    '';
    target = "samba/smb.conf";
  };
}
