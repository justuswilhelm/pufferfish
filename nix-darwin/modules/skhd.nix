# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  lib,
  pkgs,
  ...
}:
let
  mpdKeys = {
    play = "${pkgs.mpc}/bin/mpc toggle";
    rewind = "${pkgs.mpc}/bin/mpc prev";
    fast = "${pkgs.mpc}/bin/mpc next";
  };
  cmusKeys = {
    play = "${pkgs.cmus}/bin/cmus-remote -u";
    rewind = "${pkgs.cmus}/bin/cmus-remote -r";
    fast = "${pkgs.cmus}/bin/cmus-remote -n";
  };
  keys = if config.services.mpd.enable then mpdKeys else cmusKeys;
in
{
  services.skhd = {
    enable = true;
    # See this page for key names
    # https://github.com/koekeishiya/skhd/issues/1
    skhdConfig = with keys; ''
      play : ${play}
      rewind : ${rewind}
      fast : ${fast}
    '';
  };
}
