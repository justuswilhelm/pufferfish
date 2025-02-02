{ lib, pkgs, specialArgs, ... }:
{
  imports = [
    ./modules/opensnitch.nix
    ./home.nix
    ./sway.nix
    ./firefox.nix
    ./linux-packages.nix
    ./foot.nix
    ./gdb.nix
    ./locale-fix.nix
    ./gpg.nix
    ./gpg-agent.nix
    ./infosec.nix
    ./infosec-linux.nix
  ];

  home.username = "justusperlwitz";
  home.homeDirectory = specialArgs.homeDirectory;

  home.packages = [
    pkgs.tor-browser
  ];

  programs.fish.shellAliases.rebuild = "sudo nixos-rebuild switch --flake $DOTFILES/nix/generic";

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
    swayConfig = {
      text = ''
        # HiDPI setting
        output * {
          scale 1.5
        }
      '';
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

  programs.ssh = {
    matchBlocks."github.com" = {
      identityFile = "~/.ssh/id_rsa_yubikey";
    };
  };
}
