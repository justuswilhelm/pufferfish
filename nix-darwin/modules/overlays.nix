# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# TODO make this a Nix module
# nixpkgs.overlays.pufferfish.enable = true
{ ... }:
{
  nixpkgs.overlays = [
    (import ../../overlays.nix).vale
    # Make J build again on darwin
    (final: previous: {
      j = previous.j.overrideAttrs (final: previous: { meta.broken = false; });
    })
  ];
}
