# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Packages available to all users
{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.libreoffice
  ];
}
