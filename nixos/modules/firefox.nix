# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, config, ... }:
let
  firefox = config.programs.firefox.package;
  firefoxBin = "${firefox}/lib/firefox";
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
  };
  services.opensnitch = {
    rules =
      let
        processPath = {
          type = "regexp";
          operand = "process.path";
          data = firefoxBin;
        };
      in
      {
        firefox-000-reject-mozilla-subdomains = {
          name = "firefox-000-reject-mozilla-subdomains";
          description = "Forbid *.mozilla.{com,org} domains that provide no user benefit";
          created = "1970-01-01T00:00:00Z";
          updated = "1970-01-01T00:00:00Z";
          enabled = true;
          action = "reject";
          duration = "always";
          operator = {
            type = "regexp";
            sensitive = false;
            operand = "dest.host";
            data = "[^.]+\.(services|telemetry)\.mozilla\.(com|org)$";
          };
        };
        firefox-001-allow-https = {
          name = "firefox-001-allow-https";
          description = "Allow Firefox connections to port 443";
          created = "1970-01-01T00:00:00Z";
          updated = "1970-01-01T00:00:00Z";
          enabled = true;
          action = "allow";
          duration = "always";
          precedence = true;
          operator = {
            type = "list";
            operand = "list";
            list = [
              processPath
              {
                type = "simple";
                operand = "dest.port";
                data = "443";
              }
            ];
          };
        };
        # TODO refactor this
        # Right now, the OpenSnitch UI rejects the LAN dest.network
        firefox-002-allow-local-http = {
          name = "firefox-002-allow-local-http";
          description = "Allow local Firefox connections to 192.0.0.0/8 :80";
          created = "1970-01-01T00:00:00Z";
          updated = "1970-01-01T00:00:00Z";
          enabled = true;
          action = "allow";
          duration = "always";
          precedence = true;
          operator = {
            type = "list";
            operand = "list";
            list = [
              processPath
              {
                type = "simple";
                operand = "dest.port";
                data = "80";
              }
              {
                type = "network";
                operand = "dest.network";
                data = "192.0.0.0/8";
              }
            ];
          };
        };
        firefox-003-allow-local-http = {
          name = "firefox-003-allow-local-http";
          description = "Allow local Firefox connections to 10.0.0.0/24 :80";
          created = "1970-01-01T00:00:00Z";
          updated = "1970-01-01T00:00:00Z";
          enabled = true;
          action = "allow";
          duration = "always";
          precedence = true;
          operator = {
            type = "list";
            operand = "list";
            list = [
              processPath
              {
                type = "simple";
                operand = "dest.port";
                data = "80";
              }
              {
                type = "network";
                operand = "dest.network";
                data = "10.0.0.0/8";
              }
            ];
          };
        };
        firefox-004-reject-other-http = {
          name = "firefox-004-reject-other-http";
          description = "Reject Firefox connections to :80";
          created = "1970-01-01T00:00:00Z";
          updated = "1970-01-01T00:00:00Z";
          enabled = true;
          action = "reject";
          duration = "always";
          operator = {
            type = "list";
            operand = "list";
            list = [
              processPath
              {
                type = "simple";
                operand = "dest.port";
                data = "80";
              }
            ];
          };
        };
      };
  };
}
