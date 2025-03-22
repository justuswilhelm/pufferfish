{ lib, pkgs, ... }:
{
  imports = [
    ./modules/gdb.nix
    ./modules/foot.nix
    ./modules/firefox.nix

    ./home.nix
    ./sway.nix
    ./linux-packages.nix
    ./infosec.nix
    ./infosec-linux.nix
    ./gpg-agent.nix
  ];

  programs.i3status.modules = {
    "ethernet enp0s1" = {
      settings = {
        format_up = "eth: %ip (%speed)";
        format_down = "eth: down";
      };
      position = 0;
    };
  };

  programs.fish.shellAliases.rebuild = "sudo nixos-rebuild switch --flake $DOTFILES";

  xdg.configFile = {
    "sway/config.d/${osConfig.networking.hostName}".text = ''
      # HiDPI setting
      output * {
        scale 1
      }
      exec spice-vdagent
    '';
  };
}
