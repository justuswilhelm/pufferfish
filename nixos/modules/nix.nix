# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# TODO make this a Nix module
{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  environment.systemPackages = [ pkgs.nix-tree ];

  services.opensnitch.rules = lib.mkIf config.services.opensnitch.enable {
    nix = {
      name = "allow-nix";
      description = "Allow nix";
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
            type = "simple";
            operand = "process.path";
            data = "${lib.getBin config.nix.package}/bin/nix";
          }
          {
            type = "regexp";
            operand = "dest.port";
            data = "^(53|443)$";
          }
        ];
      };
    };
    curl-tarballs = {
      name = "allow-curl-tarballs-nixos-org";
      description = "Allow curl to access tarballs.nixos.org";
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
            type = "simple";
            operand = "dest.host";
            data = "tarballs.nixos.org";
          }
          {
            type = "simple";
            operand = "dest.port";
            data = "443";
          }
          {
            type = "simple";
            operand = "process.path";
            data = "${lib.getBin pkgs.curl}/bin/curl";
          }
        ];
      };
    };
  };
}
