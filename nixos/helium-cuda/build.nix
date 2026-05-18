# SPDX-FileCopyrightText: 2026 Justus Perlwitz
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  # Qemu stuff
 system.build.qcow = lib.mkForce (import "${toString modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
    diskSize = "auto";
    additionalSpace = "20G";
    format = "qcow2";
    baseName = "helium-cuda";
    installBootLoader = true;
    partitionTableType = "hybrid";
  });
}
