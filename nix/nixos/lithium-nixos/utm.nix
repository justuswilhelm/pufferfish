# Settings to run this in UTM
{ config, lib, pkgs, ... }:
{
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
