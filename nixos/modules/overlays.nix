{ ... }:
{
  nixpkgs.overlays = [
    (import ../../overlays.nix).vale
  ];
}
