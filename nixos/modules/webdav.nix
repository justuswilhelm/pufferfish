{ config, pkgs, ... }:
{
  users.users.davfs2 = {
    description = "davfs2 user";
    group = "davfs2";
    isSystemUser = true;
  };
  users.groups.davfs2 = { };

  environment.systemPackages = [
    # WebDAV
    # =====
    pkgs.davfs2
  ];
}
