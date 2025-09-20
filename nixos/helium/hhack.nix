# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Hardware hacking stuff
{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.pulseview
    pkgs.sigrok-cli
    pkgs.urjtag
    pkgs.openocd
    pkgs.libftdi
  ];
  services.udev = {
    enable = true;
    packages = [ pkgs.libsigrok ];
  };
}
