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
        processPath = { type = "regexp"; operand = "process.path"; data = firefoxBin; };
      in
      {
        forbid-mozilla = {
          name = "000-reject-firefox-mozilla-services";
          description = "Forbid *.mozilla.* domains that provide no user benefit";
          created = "1970-01-01T00:00:00Z";
          updated = "1970-01-01T00:00:00Z";
          enabled = true;
          action = "reject";
          duration = "always";
          operator = {
            type = "regexp";
            sensitive = false;
            operand = "dest.host";
            data = "[^.]+\.services\.mozilla\.com";
          };
        };
        firefox-allow-443 = {
          name = "001-allow-firefox-https";
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
              { type = "simple"; operand = "dest.port"; data = "443"; }
            ];
          };
        };
        firefox-allow-local-80 = {
          name = "002-allow-firefox-local-http";
          description = "Allow local Firefox connections to :80";
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
              { type = "simple"; operand = "dest.port"; data = "80"; }
              { type = "network"; operand = "dest.network"; data = "10.0.0.0/8"; }
            ];
          };
        };
        firefox-deny-80 = {
          name = "003-reject-firefox-http";
          description = "Deny Firefox connections to :80";
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
              { type = "simple"; operand = "dest.port"; data = "80"; }
            ];
          };
        };
      };
  };
}
