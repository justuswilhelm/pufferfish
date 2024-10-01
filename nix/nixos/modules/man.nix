{ config, lib, pkgs, ... }:
{
  documentation = {
    dev.enable = true;
    man = {
      enable = true;
      generateCaches = true;
      man-db.enable = false;
      mandoc.enable = true;
    };
    nixos.includeAllModules = true;
  };
  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
  ];
}
