# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.patchelf
  ];
  # https://github.com/nix-community/nix-ld?tab=readme-ov-file#with-nix-flake
  programs.nix-ld.enable = true;
}
