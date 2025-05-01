# Enable settings for system-wide sway installation
{ config, lib, pkgs, ... }:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [
      pkgs.bemenu
      pkgs.foot
      pkgs.grim
      pkgs.mako
      pkgs.slurp
      pkgs.swayidle
      pkgs.swaylock
      pkgs.wl-clipboard
    ];
  };
  # TODO move this to pipewire.nix module
  # From journalctl:
  # xdg-desktop-portal-wlr[4497]: 2024/08/31 07:36:18 [ERROR] - pipewire: couldn't connect to context
  # services.pipewire = {
  #   enable = true;
  #   wireplumber.enable = true;
  # };
  # xdg.portal.wlr.enable = true;
}
