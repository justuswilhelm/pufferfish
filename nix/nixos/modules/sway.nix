# Enable settings for system-wide sway installation
{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
