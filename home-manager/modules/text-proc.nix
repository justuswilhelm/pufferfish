# Packages used for mangling text
{ pkgs, ... }:
{
  home.packages = [
    pkgs.jq
    pkgs.miller
    pkgs.lnav
    pkgs.datamash
    pkgs.ripgrep
  ];
}
