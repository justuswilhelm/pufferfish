# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.tor = {
    enable = true;
    openFirewall = true;
  };

  # OpenSnitch rule allowing tor to connect to port 993 as user 35 for 12h
  services.opensnitch.rules = {
    tor-allow-tcp-ports = {
      name = "tor-allow-tcp-ports";
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
            data = "^(443|993|8080|9000|9001|18360)$";
          }
          {
            type = "simple";
            operand = "user.name";
            data = "tor";
          }
          {
            type = "simple";
            operand = "protocol";
            data = "tcp";
          }
          {
            type = "simple";
            operand = "process.path";
            data = "${lib.getBin config.services.tor.package}/bin/tor";
          }
        ];
      };
    };
  };
}
