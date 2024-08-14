{ lib, pkgs, specialArgs, ... }:
{
  imports = [
    ./home.nix
    ./sway.nix
    ./firefox.nix
    ./linux-packages.nix
    ./foot.nix
    ./gdb.nix
  ];
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
        # HiDPI setting
        output * {
          scale 1.5
        }
      '';
      target = "sway/config.d/helium";
    };
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.package = pkgs.nix;
}