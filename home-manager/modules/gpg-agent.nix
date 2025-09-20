# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
    enableSshSupport = true;
  };

  programs.ssh = {
    matchBlocks."*.local" = {
      identityFile = "~/.ssh/id_rsa_yubikey";
    };
  };
}
