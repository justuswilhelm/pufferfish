# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 51820 51822 ];
  networking.firewall.allowedUDPPorts = [ 51820 51822 ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
