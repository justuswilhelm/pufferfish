{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Replacement for programs.light
  hardware.acpilight.enable = true;
  programs.sway.extraPackages = lib.mkIf config.programs.sway.enable [
    pkgs.brightnessctl
  ];
  environment.etc."sway/config.g/light" = {
    enable = config.programs.sway.enable;
    text = ''
      # Screen brightness
      bindsym XF86MonBrightnessUp exec brightnessctl set +10
      bindsym XF86MonBrightnessDown exec brightnessctl set -10
    '';
  };
}
