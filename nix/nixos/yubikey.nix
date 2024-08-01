# Config needed to use yubikeys
{ config, lib, pkgs, ... }:
{
  services.openssh.enable = true;

  services.pcscd.enable = true;

}
