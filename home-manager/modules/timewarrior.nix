# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  xdg.configFile."timewarrior/timewarrior.cfg".source = ../../timewarrior/timewarrior.cfg;
  home.packages = [ pkgs.timewarrior ];
  programs.fish.shellAliases.tw = "timew";
  programs.fish.shellAbbrs.tws = "timew start";
  programs.fish.shellAbbrs.twc = "timew continue";
  programs.fish.shellAbbrs.twt = "timew stop";
}
