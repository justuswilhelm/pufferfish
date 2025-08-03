{ lib, pkgs, osConfig, ... }:
{
  imports = [
    # ./modules/infosec-linux.nix
    # ./modules/infosec.nix
    # ./modules/passwordstore.nix

    ./modules/canbus.nix
    ./modules/direnv.nix
    ./modules/firefox.nix
    ./modules/fish.nix
    ./modules/fonts.nix
    ./modules/foot.nix
    ./modules/git.nix
    ./modules/gpg-agent.nix
    ./modules/gpg.nix
    ./modules/linux-packages.nix
    ./modules/man.nix
    ./modules/nvim.nix
    ./modules/packages.nix
    ./modules/paths.nix
    ./modules/python.nix
    ./modules/selenized.nix
    ./modules/ssh.nix
    ./modules/sway.nix
    ./modules/tmux.nix

    ./home.nix
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

  xdg.configFile."sway/config.d/${osConfig.networking.hostName}".text = ''
    # HiDPI setting
    output * {
      scale 1
    }
    exec spice-vdagent
  '';

  home.stateVersion = "24.05";
}
