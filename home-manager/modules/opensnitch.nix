# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib, pkgs, ... }:
{
  services.opensnitch-ui.enable = true;
  home.packages = [
    pkgs.opensnitch-ui
  ];
}
