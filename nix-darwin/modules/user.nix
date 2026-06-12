# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# TODO make this a Nix module
# users.add_default_user = true
{ pkgs, config, ... }:
let
  name = config.system.primaryUser;
in
{
  users.users.${name} = {
    description = name;
    shell = pkgs.fish;
    home = "/Users/${name}";
    uid = 501;
  };
}
