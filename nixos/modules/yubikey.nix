# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Config needed to use yubikeys
{ config, lib, pkgs, ... }:
{
  # For servers
  services.openssh.enable = true;

  #  For clients
  programs.ssh.startAgent = false;
  services.pcscd.enable = true;

  # https://nixos.wiki/wiki/Yubikey
  # Add key cfg
  # mkdir -p $HOME/.config/Yubico
  # pamu2fcfg > $HOME/.config/Yubico/u2f_keys
  # Test all three:
  # pamtester login $USER authenticate
  # pamtester sudo $USER authenticate
  # pamtester swaylock $USER authenticate
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    swaylock.u2fAuth = true;
  };
  environment.systemPackages = [
    pkgs.pam_u2f
    pkgs.pamtester
    pkgs.yubikey-manager
  ];
}
