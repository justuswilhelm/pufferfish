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
      ngn-k = previous.ngn-k.overrideAttrs (oldAttrs: {

        src = previous.fetchFromGitea {
          domain = "codeberg.org";
          owner = "growler";
          repo = "k";
          rev = "e066c4b4b89832d690abebe3973744ccdf6e3bcb";
          sha256 = "sha256-hN5H35S/Zy9sW9yyBuDs0QWvtxvdAqavQAXE1EFzemc=";
        };
  patches = [
    ./repl-license-path.patch
    ./repl-argv-1.patch
  ];
        meta.platforms = oldAttrs.meta.platforms ++ [ "aarch64-darwin" ];
      });
    })
  ];
}
