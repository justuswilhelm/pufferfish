{ lib, pkgs, ... }:
{
  services.opensnitch-ui.enable = true;
  home.packages = [
    pkgs.opensnitch-ui
  ];
}
