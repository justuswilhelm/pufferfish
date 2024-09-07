# Enable settings for system-wide sway installation
{ config, lib, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/2419b85a5eb75262b00a359c693d94b4aa9e880a/nixos/modules/services/x11/display-managers/default.nix#L238C1-L243C7
  # https://wiki.archlinux.org/title/Sway#Manage_Sway-specific_daemons_with_systemd
  systemd.user.targets.sway-session = {
    unitConfig = {
      Description = "Sway compositor session";
      Documentation = "man:systemd.special";
      BindsTo = "graphical-session.target";
      Wants = "graphical-session-pre.target";
      After = "graphical-session-pre.target";
    };
  };
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
