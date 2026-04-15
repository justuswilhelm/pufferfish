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

    # GUI tools
    # =========
    pkgs.zeal
    # Markdown writer
    pkgs.kdePackages.ghostwriter

    # Nix
    # ===
    # Not available on Darwin
    pkgs.cntr

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
