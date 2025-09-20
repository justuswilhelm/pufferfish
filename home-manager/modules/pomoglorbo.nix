# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  home.packages = [ pkgs.pomoglorbo ];
  xdg.configFile."pomoglorbo/config.ini".source = ../../pomoglorbo/config.ini;
  programs.fish.shellAliases = {
    p = "pomoglorbo";
  };
}
