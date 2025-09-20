# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      # Reload fish session. Useful if config.fish has changed.
      reload = "exec fish";
      # Ls shortcut with color, humanized, list-based output
      l = "ls -lhaG";
    };
  };

  xdg.configFile = {
    "fish/functions" = {
      source = ../../fish/functions;
      recursive = true;
    };
    "fish/completions" = {
      source = ../../fish/completions;
      recursive = true;
    };
  };
}
