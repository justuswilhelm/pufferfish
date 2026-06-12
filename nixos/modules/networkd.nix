# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  lib,
  config,
  pkgs,
  ...
}:
{
  # systemd networkd and resolved config
  systemd.network = {
    enable = true;
    networks = {
      "10-ethernet" = {
        matchConfig = {
          # Prevent networkd from messing with libvirt bridges
          # Add more pci paths for other devices
          Path = "pci-0000:0?:0?.0";
          Type = "ether";
        };
        networkConfig = {
          DHCP = "ipv4";
          MulticastDNS = "yes";
          LinkLocalAddressing = "no";
        };
      };
      "20-wlan" = {
        matchConfig = {
          Type = "wlan";
        };
        networkConfig = {
          DHCP = "ipv4";
          MulticastDNS = "yes";
          LinkLocalAddressing = "no";
        };
      };
    };
  };
  networking.useNetworkd = true;
  services.resolved = {
    enable = true;
    # domains = [ "~." ];
    extraConfig = ''
      DNSStubListener = udp
    '';
    llmnr = "false";
  };
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [
    # mDNS
    5353
  ];
  services.opensnitch.rules = lib.mkIf config.services.opensnitch.enable {
    systemd-allow-resolved-dhcp = {
      name = "systemd-allow-resolved-dhcp";
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
            data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
          }
          {
            type = "simple";
            operand = "protocol";
            data = "udp";
          }
          {
            type = "simple";
            operand = "dest.port";
            data = "67";
          }
        ];
      };
    };
    systemd-allow-resolved-udp = {
      name = "systemd-allow-resolved-udp";
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
          {
            type = "simple";
            operand = "process.path";
            data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
          }
          {
            type = "simple";
            operand = "protocol";
            data = "udp";
          }
          {
            type = "regexp";
            operand = "dest.port";
            data = "^(53|5353)$";
          }
        ];
      };
    };
    systemd-allow-resolved-udp-6 = {
      name = "systemd-allow-resolved-udp-6";
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
          {
            type = "simple";
            operand = "process.path";
            data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
          }
          {
            type = "simple";
            operand = "protocol";
            data = "udp6";
          }
          {
            type = "regexp";
            operand = "dest.port";
            data = "^(53|5353)$";
          }
        ];
      };
    };
  };
}
