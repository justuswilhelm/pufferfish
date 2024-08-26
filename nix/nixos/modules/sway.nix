# Enable settings for system-wide sway installation
{ config, lib, pkgs, ... }:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [
      pkgs.foot
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.mako
      pkgs.swaylock
    ];
  };
}
