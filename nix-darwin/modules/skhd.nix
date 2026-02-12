# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  services.skhd = {
    enable = true;
    # https://github.com/koekeishiya/skhd/issues/1
    skhdConfig =
      let
        mpc = "${pkgs.mpc}/bin/mpc";
      in
      ''
        play : ${mpc} toggle
        rewind : ${mpc} prev
        fast : ${mpc} next
      '';
  };
}
