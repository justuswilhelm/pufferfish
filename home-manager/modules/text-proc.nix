# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Packages used for mangling text
{ pkgs, ... }:
{
  home.packages = [
    pkgs.jq
    pkgs.miller
    pkgs.lnav
    pkgs.datamash
    pkgs.ripgrep
  ];
}
