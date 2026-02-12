# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Hardware hacking stuff
{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.pulseview
    pkgs.sigrok-cli
    pkgs.urjtag
    pkgs.openocd
    pkgs.libftdi
    # uname -a says 6.12.64 Justus 2026-02-12
    pkgs.linuxKernel.packages.linux_6_12.usbip
  ];
  services.udev = {
    enable = true;
    packages = [ pkgs.libsigrok ];
  };
}
