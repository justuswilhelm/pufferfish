{ lib, pkgs, specialArgs, ... }:
{
  imports = [ ./home.nix ./sway.nix ./firefox.nix ];
  home.packages = [
    pkgs.tor-browser
  ];

  programs.i3status.modules = {
    "ethernet enp7s0" = {
      settings = {
        format_up = "enp7s0: %ip (%speed)";
        format_down = "enp7s0: down";
      };
      position = 0;
    };
  };

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

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.package = pkgs.nix;
}
