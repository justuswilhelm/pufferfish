# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 12;
        normal = {
          family = "Iosevka Fixed";
        };
      };
      window = {
        option_as_alt = "OnlyRight";
      };
    };
  };
}
