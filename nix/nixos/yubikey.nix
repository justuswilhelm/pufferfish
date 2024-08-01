# Config needed to use yubikeys
{ config, lib, pkgs, ... }:
{
  services.openssh.enable = true;

  services.pcscd.enable = true;
  # https://nixos.wiki/wiki/Yubikey
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
