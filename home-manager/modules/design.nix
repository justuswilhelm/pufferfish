# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Graphics and design related packages
{ pkgs, ... }:
{
  home.packages = [
    pkgs.librecad
    pkgs.freecad
  ];
}
