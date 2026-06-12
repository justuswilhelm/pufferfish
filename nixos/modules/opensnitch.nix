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
  # https://nixos.wiki/wiki/OpenSnitch
  # https://github.com/evilsocket/opensnitch/wiki/Rules
  services.opensnitch = {
    enable = true;
    settings = {
      DefaultAction = "deny";
    };
    rules = {
      systemd-timesyncd = {
        name = "systemd-allow-timesyncd";
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
              data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
            }
            {
              type = "simple";
              operand = "protocol";
              data = "udp";
            }
            {
              type = "regexp";
              operand = "dest.port";
              data = "^(53|123)$";
            }
          ];
        };
      };
      allow-local-dns = {
        name = "!-all-allow-local-dns";
        description = "Allow processes to access 127.0.0.0/24 53/udp";
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
              type = "network";
              operand = "dest.network";
              data = "127.0.0.0/24";
            }
            {
              type = "simple";
              operand = "protocol";
              data = "udp";
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "53";
            }
          ];
        };
      };
      forbid-other-dns = {
        name = "~-all-reject-other-dns";
        description = "Forbid other processes from sending on 53/udp";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "reject";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            {
              type = "simple";
              operand = "protocol";
              data = "udp";
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "53";
            }
          ];
        };
      };
      git-remote-http = {
        name = "git-allow-git-remote-http";
        description = "Allow git-remote-http TCP to port 443";
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
              data = "${lib.getBin pkgs.git}/libexec/git-core/git-remote-http";
            }
            {
              type = "simple";
              operand = "protocol";
              data = "tcp";
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "443";
            }
          ];
        };
      };
      mosh-client = {
        name = "mosh-allow-local-udp";
        description = "Allow mosh-client to local network on UDP ports 60000-60100";
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
              type = "network";
              operand = "dest.network";
              data = "10.0.0.0/16";
            }
            {
              type = "regexp";
              operand = "dest.port";
              data = "^600\\d\\d$";
            }
            {
              type = "simple";
              operand = "protocol";
              data = "udp";
            }
            {
              type = "simple";
              operand = "process.path";
              data = "${lib.getBin pkgs.mosh}/bin/mosh-client";
            }
          ];
        };
      };
      git-ssh = {
        name = "git-allow-ssh-local-user";
        description = "Allow git SSH to local network on TCP port 22";
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
              type = "network";
              operand = "dest.network";
              data = "10.0.0.0/16";
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "22";
            }
            {
              type = "simple";
              operand = "user.id";
              data = "1000";
            }
            {
              type = "simple";
              operand = "protocol";
              data = "tcp";
            }
            {
              type = "simple";
              operand = "process.path";
              data = "${lib.getBin pkgs.openssh}/bin/ssh";
            }
          ];
        };
      };
      perl-ssh = {
        name = "mosh-allow-perl-ssh";
        description = "Allow perl SSH to local network on TCP port 22";
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
              type = "network";
              operand = "dest.network";
              data = "10.0.0.0/16";
            }
            {
              type = "simple";
              operand = "user.id";
              data = "1000";
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "22";
            }
            {
              type = "simple";
              operand = "protocol";
              data = "tcp";
            }
            {
              type = "simple";
              operand = "process.path";
              data = "${lib.getBin pkgs.perl}/bin/perl";
            }
          ];
        };
      };
      nmap = {
        name = "nmap-allow-all";
        description = "Allow nmap to connect everywhere";
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
      # Home configuration installs aider, not possible to configure OpenSnitch
      # from home configuration.
      aider-allow-hosts = {
        name = "aider-allow-hosts";
        description = "Allow Aider to some hosts";
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
              operand = "process.command";
              data = "/etc/profiles/per-user/[^/]+/bin/aider";
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "443";
            }
            {
              type = "simple";
              operand = "protocol";
              data = "tcp";
            }
            {
              type = "regexp";
              operand = "dest.host";
              data = "^(raw.githubusercontent.com|openrouter.ai)$";
            }
          ];
        };
      };
      signal = {
        name = "signal-allow-signal-org";
        description = "Allow Signal to access *.signal.org";
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
              operand = "process.path";
              # "data": "/nix/store/9j99q6zbwhb57w85qg0bra65x7778pmy-electron-unwrapped-39.5.2/libexec/electron/electron"
              data = "${lib.getBin pkgs.electron.passthru.unwrapped}/libexec/electron/electron";
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "443";
            }
            {
              type = "simple";
              operand = "protocol";
              data = "tcp";
            }
            {
              type = "regexp";
              operand = "dest.host";
              data = "^(grpc\.chat|cnd3|storage)\.signal\.org$";
            }
          ];
        };
      };
    };
  };
}
