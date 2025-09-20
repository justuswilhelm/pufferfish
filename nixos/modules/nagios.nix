# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, pkgs, ... }:
let
  nsca = (import ../../nix-darwin/modules/nagios/nsca.nix) { inherit pkgs; };
  sendNscaConfig = pkgs.writeText "send_nsca.cfg" ''

'';
in
{
  environment.etc."nagios/send_nsca.conf".source = sendNscaConfig;
  environment.systemPackages = [
    nsca
  ];
}
