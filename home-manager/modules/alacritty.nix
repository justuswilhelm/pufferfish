# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 12;
        normal = {
          family = "Iosevka Fixed";
        };
      };
      # TODO check if we can check if nixosConfig.users.users.${specialArgs.name} has
      # enabled fish
      terminal.shell = lib.mkIf config.programs.fish.enable {
        program = "${config.programs.fish.package}/bin/fish";
        args = [ "-l" ];
      };
      window = {
        option_as_alt = "OnlyRight";
      };
    };
  };
}
