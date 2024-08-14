{ lib, pkgs, specialArgs, ... }:
{
  imports = [
    ./home.nix
    ./sway.nix
    ./firefox.nix
    ./linux-packages.nix
    ./foot.nix
  ];

  programs.fish.loginShellInit = ''
    # If running from tty1 start sway
    if [ (tty) = /dev/tty1 ]
        exec sway
    end
  '';

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
      '';
      target = "sway/config.d/nitrogen";
    };
  };
  program.i3status.modules."battery 0" = {
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
}
