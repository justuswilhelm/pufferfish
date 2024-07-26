{ lib, pkgs, specialArgs, ... }:
{
  imports = [ ./home.nix ./sway.nix ];
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
}
