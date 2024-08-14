{ lib, ... }:
let
  selenized = (import ./selenized.nix) { inherit lib; };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 12;
        normal = {
          family = "Iosevka Fixed";
        };
      };
      window = {
        option_as_alt = "OnlyRight";
      };
    } // selenized.alacritty;
  };
}
