# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ ... }:
{
  nixpkgs.overlays = [
    (import ../../overlays.nix).vale
  ];
}
