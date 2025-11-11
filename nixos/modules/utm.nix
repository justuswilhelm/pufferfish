# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Settings to run this in UTM
{ config, lib, pkgs, ... }:
{
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  systemd.services.spice-vdagentd.wantedBy = [
    "multi-user.target"
  ];
  environment.systemPackages = [
    pkgs.xorg.xrandr
  ];
}
