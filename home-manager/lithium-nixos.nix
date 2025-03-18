{ lib, pkgs, ... }:
{
  imports = [
    ./modules/direnv.nix
    ./modules/firefox.nix
    ./modules/fonts.nix
    ./modules/foot.nix
    ./modules/gpg.nix
    ./modules/man.nix
    ./modules/paths.nix
    ./modules/pdb.nix
    ./modules/poetry.nix
    ./modules/ssh.nix

    ./fish.nix
    ./git.nix
    ./gpg-agent.nix
    # ./infosec-linux.nix
    # ./infosec.nix
    ./linux-packages.nix
    ./nvim.nix
    ./packages.nix
    ./passwordstore.nix
    ./selenized.nix
    ./sway.nix
    ./tmux.nix
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

  programs.fish.loginShellInit = ''
    # If running from tty1 start sway
    if [ (tty) = /dev/tty1 ]
        exec sway
    end
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  xdg.configFile = {
    swayLithiumNixOs = {
      text = ''
        # HiDPI setting
        output * {
          scale 1
        }
        exec spice-vdagent
      '';
      target = "sway/config.d/sway-lithium-nixos";
    };
  };

  home.stateVersion = "24.05";
}
