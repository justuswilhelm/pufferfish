{ lib, pkgs, specialArgs, ... }:
{
  imports = [ ./home.nix ./sway.nix ./firefox.nix ];
  programs.fish.loginShellInit = ''
    # Only need to source this once
    source /nix/var/nix/profiles/default/etc/profile.d/nix.fish

    # If running from tty1 start sway
    if [ (tty) = /dev/tty1 ]
        exec sway
    end
  '';
  xdg.configFile = {
    swayHelium = {
      text = ''
        input type:keyboard {
          xkb_layout x280
        }
        # HiDPI setting
        output * {
          scale 1.5
        }
        exec ${pkgs.keepassxc}/bin/keepassxc
      '';
      target = "sway/config.d/helium";
    };
  };
}
