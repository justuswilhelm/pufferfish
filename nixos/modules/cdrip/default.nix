# SPDX-FileCopyrightText: 2026 Justus Perlwitz
# SPDX-License-Identifier: GPL-3.0-or-later
# Configuration for ripping CDs
{
  specialArgs,
  pkgs,
  ...
}:
{
  users.users.${specialArgs.name} = {
    extraGroups = [ "cdrom" ];
    packages = with pkgs; [
      cdparanoia
      freac
      flac
      picard
      cddiscid
      libcddb
      whipper
    ];
  };
  home-manager.users.${specialArgs.name}.xdg.configFile."whipper/whipper.conf".source =
    ./whipper.conf;
}
