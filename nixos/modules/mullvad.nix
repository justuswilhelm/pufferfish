# Mullvad configuration
{ config, lib, pkgs, specialArgs, ... }:
{
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
}
