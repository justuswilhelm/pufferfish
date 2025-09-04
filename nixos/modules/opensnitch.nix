{ lib, pkgs, config, ... }:
{
  # https://nixos.wiki/wiki/OpenSnitch
  # https://github.com/evilsocket/opensnitch/wiki/Rules
  services.opensnitch = {
    enable = true;
    rules = {
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "simple"; operand = "process.path"; data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd"; }
            { type = "simple"; operand = "protocol"; data = "udp"; }
            { type = "regexp"; operand = "dest.port"; data = "^(53|123)$"; }
          ];
        };
      };
      systemd-resolved = {
        name = "systemd-resolved";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "simple"; operand = "process.path"; data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved"; }
            { type = "simple"; operand = "protocol"; data = "udp"; }
            { type = "regexp"; operand = "dest.port"; data = "^(53|5353)$"; }
          ];
        };
      };
      git-remote-http = {
        name = "Allow git-remote-http TCP to port 443";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "simple"; operand = "process.path"; data = "${lib.getBin pkgs.git}/libexec/git-core/git-remote-http"; }
            { type = "simple"; operand = "protocol"; data = "tcp"; }
            { type = "simple"; operand = "dest.port"; data = "443"; }
          ];
        };
      };
      nix = {
        name = "Allow nix";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "simple"; operand = "process.path"; data = "${lib.getBin pkgs.nix}/bin/nix"; }
            { type = "regexp"; operand = "dest.port"; data = "^(53|443)$"; }
          ];
        };
      };
      mosh-client = {
        name = "Allow mosh-client to local network on UDP ports 60000-60100";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "network"; operand = "dest.network"; data = "10.0.0.0/16"; }
            { type = "regexp"; operand = "dest.port"; data = "^600\\d\\d$"; }
            { type = "simple"; operand = "protocol"; data = "udp"; }
            {
              type = "simple";
              operand = "process.path";
              data = "${lib.getBin pkgs.mosh}/bin/mosh-client";
            }
          ];
        };
      };
      git-ssh = {
        name = "Allow git SSH to local network on TCP port 22";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "network"; operand = "dest.network"; data = "10.0.0.0/16"; }
            { type = "simple"; operand = "dest.port"; data = "22"; }
            { type = "simple"; operand = "user.id"; data = "1000"; }
            { type = "simple"; operand = "protocol"; data = "tcp"; }
            {
              type = "simple";
              operand = "process.path";
              data = "${lib.getBin pkgs.openssh}/bin/ssh";
            }
          ];
        };
      };
      perl-ssh = {
        name = "Allow perl SSH to local network on TCP port 22";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "network"; operand = "dest.network"; data = "10.0.0.0/16"; }
            { type = "simple"; operand = "user.id"; data = "1000"; }
            { type = "simple"; operand = "dest.port"; data = "22"; }
            { type = "simple"; operand = "protocol"; data = "tcp"; }
            {
              type = "simple";
              operand = "process.path";
              data = "${lib.getBin pkgs.perl}/bin/perl";
            }
          ];
        };
      };
      nmap = {
        name = "Allow nmap to connect everywhere";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.nmap}/bin/nmap";
        };
      };
    };
  };
}
