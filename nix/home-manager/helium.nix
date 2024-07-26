{ lib, pkgs, specialArgs, ... }:
{
  imports = [ ./home.nix ];
  programs.fish.loginShellInit = ''
    # Only need to source this once
    source /nix/var/nix/profiles/default/etc/profile.d/nix.fish

    # If running from tty1 start sway
    if [ (tty) = /dev/tty1 ]
        exec sway
    end
  '';
}
