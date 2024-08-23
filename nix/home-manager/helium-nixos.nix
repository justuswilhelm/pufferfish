{ lib, pkgs, specialArgs, ... }:
{
  imports = [
    ./home.nix
    ./sway.nix
    ./firefox.nix
    ./linux-packages.nix
    ./foot.nix
    ./gdb.nix
    ./locale-fix.nix
    ./gpg.nix
    ./gpg-agent.nix
  ];

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

  xdg.configFile = {
    swayHeliumNixos = {
      text = ''
        # HiDPI setting
        output * {
          scale 1.5
        }
      '';
      target = "sway/config.d/helium-nixos";
    };
  };

  xresources = {
    properties = {
      # Dell U2720qm bought 2022 on Amazon Japan
      # Has physical width x height
      # 60.5 cm * 33.4 cm (approx)
      # and claims 27 inches with 4K resolution (3840 x 2160)
      # Which if we plug into
      # https://www.sven.de/dpi/
      # gives us
      "Xft.dpi" = 163;
    };
  };
}
