# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, ... }:
{
  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];
  home.packages = [
    # If pkgs.gcc is in the env as well, bad things happen with libiconv
    # and other macOS available binaries.
    pkgs.rustup
  ];
}
