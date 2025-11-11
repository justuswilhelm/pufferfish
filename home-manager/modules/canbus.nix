# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }: {
  home.packages = [
    pkgs.can-utils
    pkgs.usbutils
    pkgs.cannelloni
  ];
}
