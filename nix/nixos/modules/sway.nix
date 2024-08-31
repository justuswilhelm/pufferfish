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
      pkgs.swayidle
    ];
  };
  # From journalctl:
  # xdg-desktop-portal-wlr[4497]: 2024/08/31 07:36:18 [ERROR] - pipewire: couldn't connect to context
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
  };
  xdg.portal.wlr.enable = true;
}
