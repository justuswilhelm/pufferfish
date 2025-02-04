{ lib, pkgs, specialArgs, ... }:
{
  imports = [
    ./modules/gdb.nix
    ./modules/foot.nix

    ./home.nix
    ./sway.nix
    ./firefox.nix
    ./linux-packages.nix
    ./infosec.nix
    ./infosec-linux.nix
    ./gpg-agent.nix
  ];

  programs.i3status.modules = {
    "ethernet enp0s5u3c2" = {
      settings = {
        format_up = "eth: %ip (%speed)";
        format_down = "eth: down";
      };
      position = 0;
    };
  };

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
}
