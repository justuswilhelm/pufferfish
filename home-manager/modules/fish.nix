# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      # Reload fish session. Useful if config.fish has changed.
      reload = "exec fish";
      # ls shortcut with color, humanized, list-based output
      l = "ls -lhaG";
      dotfiles = "cd $DOTFILES";
      # _C_d into a _T_emporary directory
      ct = "cd (mktemp -d)";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
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
