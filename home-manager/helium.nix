{ lib, pkgs, osConfig, ... }:
{
  imports = [
    ./modules/aider.nix
    ./modules/firefox.nix
    ./modules/foot.nix
    ./modules/gdb.nix
    ./modules/gpg-agent.nix
    ./modules/infosec.nix
    ./modules/infosec-linux.nix
    ./modules/linux-packages.nix
    # TODO Investigate if this fix is needed on NixOS
    ./modules/locale-fix.nix
    ./modules/mitmproxy.nix
    ./modules/opensnitch.nix
    ./modules/packages.nix
    ./modules/pipx.nix
    ./modules/sway.nix
    ./modules/writing.nix

    ./home.nix
  ];

  home.packages = [
    pkgs.tor-browser
  ];

  programs.fish.shellAliases.rebuild = "sudo nixos-rebuild switch --flake $DOTFILES";

  programs.i3status.modules = {
    "ethernet enp7s0" = {
      settings = {
        format_up = "enp7s0: %ip (%speed)";
        format_down = "enp7s0: down";
      };
      position = 0;
    };
  };

  xdg.configFile."sway/config.d/${osConfig.networking.hostName}".text = ''
    # HiDPI setting
    output * {
      scale 1.5
    }
    # Slow down my cheap logitech mouse (logicool here in JP)
    input "1133:49271:Logitech_USB_Optical_Mouse" {
      accel_profile "flat"
      pointer_accel 0.0
    }
  '';

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

  home.stateVersion = "24.05";
}
