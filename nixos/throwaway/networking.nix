# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ ... }:
{
  networking.wireless.userControlled.enable = true;

  systemd.network.wait-online.enable = false;
}
