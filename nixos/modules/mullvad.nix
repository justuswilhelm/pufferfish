# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Mullvad configuration
{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  services.opensnitch.rules.mullvad-daemon = {
    name = "mullvad-allow-daemon";
    description = "Allow the root Mullvad daemon to connect to port 53/443";
    created = "1970-01-01T00:00:00Z";
    updated = "1970-01-01T00:00:00Z";
    enabled = true;
    action = "allow";
    duration = "always";
    operator = {
      type = "list";
      operand = "list";
      list = [
        {
          type = "regexp";
          operand = "dest.port";
          data = "^(53|443)$";
        }
        {
          type = "simple";
          operand = "user.id";
          data = "0";
        }
        {
          type = "simple";
          operand = "process.path";
          data = "${lib.getBin config.services.mullvad-vpn.package}/bin/.mullvad-daemon-wrapped";
        }
      ];
    };
  };
}
