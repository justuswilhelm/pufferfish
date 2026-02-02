# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file contains modules that are safe to import by default

{
  lib,
  pkgs,
  config,
  options,
  ...
}:
{
  imports = [
    ./modules/cmus.nix
    ./modules/direnv.nix
    ./modules/fish.nix
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/gpg.nix
    ./modules/man.nix
    ./modules/nnn.nix
    ./modules/nvim.nix
    ./modules/passwordstore.nix
    ./modules/paths.nix
    ./modules/python.nix
    ./modules/selenized.nix
    ./modules/ssh.nix
    ./modules/tmux.nix

    # Supports enable, so safe to always include
    ./modules/radare.nix
  ];
}
