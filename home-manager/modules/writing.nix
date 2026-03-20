# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
let
in
{
  home.packages = [
    # Document conversion
    pkgs.pandoc
    pkgs.texliveTeTeX

    # Spellcheckers
    (pkgs.aspellWithDicts (
      ds: with ds; [
        en
        en-computers
      ]
    ))
    (pkgs.hunspell.withDicts (d: [ d.en-us ]))
    pkgs.valeWithStyles
  ];
}
