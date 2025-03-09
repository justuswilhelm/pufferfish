{ config, lib, pkgs, ... }:
{
  documentation = {
    dev.enable = true;
    man = {
      enable = true;
      man-db.enable = false;
      mandoc.enable = true;
      generateCaches = lib.mkForce false;
    };
    nixos.includeAllModules = true;
  };
  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
  ];
}
