{ lib, pkgs, osConfig, ... }:
let
  modelName = "x280";
in
{
  imports = [
    ./modules/aider.nix
    ./modules/design.nix
    ./modules/firefox.nix
    ./modules/foot.nix
    ./modules/gdb.nix
    ./modules/gpg-agent.nix
    ./modules/infosec.nix
    ./modules/infosec-linux.nix
    ./modules/linux-packages.nix
    ./modules/packages.nix
    ./modules/ssh.nix
    ./modules/sway.nix

    # TODO enable
    # ./modules/opensnitch.nix

    ./home.nix
  ];

  home.packages = [
    pkgs.tor-browser
    pkgs.powertop
  ];

  programs.fish.shellAliases.rebuild = "sudo nixos-rebuild switch --flake $DOTFILES";

  home.file.".xkb/symbols/${modelName}".text = ''
    default partial alphanumeric_keys
    xkb_symbols "basic" {
      include "us(basic)"

      name[Group1] = "${modelName} keyboard";
      key <CAPS>  {[ Return      ]       };
    };
  '';
  xdg.configFile."sway/config.d/${osConfig.networking.hostName}".text = ''
    input type:keyboard {
      xkb_layout ${modelName}
    }
    # HiDPI setting
    output * {
      scale 1.25
    }

    output eDP-1 pos 0 0 res 1920x1080
    # Configure the HDMI-2 output like so:
    # output HDMI-A-2 pos 1920 0 res 1920x1080

    # Screen brightness
    bindsym XF86MonBrightnessUp exec light -A 10
    bindsym XF86MonBrightnessDown exec light -U 10

    # Audio
    bindsym XF86AudioRaiseVolume exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
    bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindsym XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  '';

  programs.i3status.modules = {
    "wireless wlp59s0" = {
      settings = {
        format_up = "wlp59s0: %ip (%quality)";
        format_down = "wlp59s0: down";
      };
      position = 0;
    };
    "battery 0" = {
      settings = {
        format = "%status %percentage %remaining %emptytime";
        format_down = "No battery";
        status_chr = "⚡ CHR";
        status_bat = "🔋 BAT";
        status_unk = "? UNK";
        status_full = "☻ FULL";
        path = "/sys/class/power_supply/BAT%d/uevent";
        low_threshold = 10;
      };
      position = 7;
    };
  };

  home.stateVersion = "24.05";
}
