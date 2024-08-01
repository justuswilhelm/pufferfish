{ lib, pkgs, specialArgs, ... }:
{
  imports = [ ./home.nix ./sway.nix ./firefox.nix ];

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
      '';
      target = "sway/config.d/sway-lithium-nixos";
    };
  };
}
