{ lib, pkgs, ... }:
{
  imports = [
    ./home.nix
    ./sway.nix
    ./firefox.nix
    ./linux-packages.nix
    ./foot.nix
    ./gdb.nix
    # Investigate if this fix is needed on NixOS
    ./locale-fix.nix
    ./gpg.nix
    ./gpg-agent.nix
    ./infosec.nix
    ./infosec-linux.nix
  ];

  home.username = "justusperlwitz";

  home.packages = [
    pkgs.tor-browser
  ];

  programs.fish.loginShellInit = ''
    # If running from tty1 start sway
    if [ (tty) = /dev/tty1 ]
        exec sway
    end
  '';

  programs.fish.shellAliases.rebuild = "sudo nixos-rebuild switch --flake $DOTFILES/nix/generic";

  home.file = {
    keyboardLayout = {
      text = ''
        default partial alphanumeric_keys
        xkb_symbols "basic" {
          include "us(basic)"

          name[Group1] = "X280 keyboard";
          key <CAPS>  {[ Return      ]       };
        };
      '';
      target = ".xkb/symbols/x280";
    };
  };
  xdg.configFile = {
    swayNitrogen = {
      text = ''
        input type:keyboard {
          xkb_layout x280
        }
        # HiDPI setting
        output * {
          scale 1.25
        }
        bindsym XF86MonBrightnessUp exec light -A 10
        bindsym XF86MonBrightnessDown exec light -U 10

        # Audio
        bindsym XF86AudioRaiseVolume exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
        bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bindsym XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      '';
      target = "sway/config.d/nitrogen";
    };
  };

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
}
