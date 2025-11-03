# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# WLAN configuration for management and debugging
{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.wirelesstools
    pkgs.iw
    pkgs.aircrack-ng
  ];
}
