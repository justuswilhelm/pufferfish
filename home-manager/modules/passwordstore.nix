# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, config, ... }:
let
  pass = pkgs.pass.withExtensions (exts: with exts; [ pass-file ]);
in
{
  home.sessionVariables = {
    # Thx to
    # https://github.com/drduh/YubiKey-Guide/issues/152#issuecomment-852176877
    PASSWORD_STORE_GPG_OPTS = "--no-throw-keyids";
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
  };
  home.packages = [ pass pkgs.diceware pkgs.yubikey-manager ];
}
