# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  home.packages = [
    # File management
    # ===============
    pkgs.ncdu
    pkgs.file

    # Nix
    # ===
    # Not available on Darwin
    pkgs.cntr

    # Remote desktop
    # ==============

    # TTY tools
    # =========
    pkgs.tio

    # System tools
    # ============
    pkgs.pciutils
    pkgs.usbutils

    # Build tools
    # ===========
  ];
}
