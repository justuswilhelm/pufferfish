# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib, pkgs, config, options, ... }:
{
  home.file.".screenrc".text = ''
    defscrolblack ${toString (10 * 1000 * 1000)}
  '';
}
