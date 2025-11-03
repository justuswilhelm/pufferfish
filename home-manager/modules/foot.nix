# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, config, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # Install foot-themes
        include = "${config.programs.foot.package.themes}/share/foot/themes/selenized-light";
        font = "Iosevka Fixed:size=11";
      };
    };
  };
}
