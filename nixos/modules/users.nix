# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ specialArgs, pkgs, ... }:
{
  users.users.${specialArgs.name} = {
    isNormalUser = true;
    extraGroups = [
      # Enable sudo
      "wheel"
      # allow using virtd
      "libvirtd"
      # For serial port
      # https://wiki.nixos.org/wiki/Serial_Console#Unprivileged_access_to_serial_device
      "dialout"
    ];
    home = "/home/${specialArgs.name}";
    shell = pkgs.fish;
  };
}
