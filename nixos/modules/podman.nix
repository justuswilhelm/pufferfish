# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.dive
    pkgs.podman-tui
    pkgs.podman-compose
    pkgs.skopeo
  ];
}
