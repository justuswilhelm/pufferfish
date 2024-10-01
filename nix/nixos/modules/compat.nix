{ config, lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.patchelf
  ];
  # https://github.com/nix-community/nix-ld?tab=readme-ov-file#with-nix-flake
  programs.nix-ld.enable = true;
}
