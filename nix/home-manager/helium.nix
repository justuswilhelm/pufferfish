{ lib, pkgs, specialArgs, ... }:
{
  imports = [
    ./home.nix
    ./sway.nix
    ./fish-debian.nix
    ./firefox.nix
    ./linux-packages.nix
    ./foot.nix
    ./gdb.nix
    ./locale-fix.nix
  ];

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
