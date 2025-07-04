# TODO make this a Nix module
{ config, lib, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  environment.systemPackages = [
    pkgs.nix-tree
  ];
}
