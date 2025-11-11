# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, ... }:
{
  users.users.davfs2 = {
    description = "davfs2 user";
    group = "davfs2";
    isSystemUser = true;
  };
  users.groups.davfs2 = { };

  environment.systemPackages = [
    # WebDAV
    # =====
    pkgs.davfs2
  ];
}
