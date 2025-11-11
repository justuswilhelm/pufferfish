# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, ... }:
{
  nix.nixPath = [ "/nix/var/nix/profiles/per-user/root/channels" ];
  nix.extraOptions = ''
    experimental-features = flakes nix-command
  '';
  nix.settings = {
    sandbox = true;
    extra-sandbox-paths = [ "/nix/store" ];
  };
  nix.optimise.automatic = true;
}
