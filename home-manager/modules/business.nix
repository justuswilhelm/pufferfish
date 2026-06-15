# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  home.packages = [
    pkgs.hledger
    pkgs.hledger-web
    pkgs.hledger-iadd
    pkgs.khal
    pkgs.khard
  ];
}
