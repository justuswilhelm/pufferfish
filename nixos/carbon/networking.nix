# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ ... }:
{
  # Pick only one of the below networking options.
  networking.wireless = {
    enable = true; # Enables wireless support via wpa_supplicant.
    secretsFile = "/etc/wireless-credentials/wireless.env";
    networks = {
      "home sweet home".pskRaw = "ext:HOME_PSK";
      "boron".pskRaw = "ext:BORON_PSK";
    };
    userControlled = true;
  };

  systemd.network.wait-online.enable = false;
}
