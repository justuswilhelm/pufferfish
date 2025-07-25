{ lib, pkgs, config, ... }:
let
  firefox = config.programs.firefox.package;
  firefoxBin = "${firefox}/lib/firefox";
in
{
  # https://nixos.wiki/wiki/OpenSnitch
  # https://github.com/evilsocket/opensnitch/wiki/Rules
  services.opensnitch = {
    enable = true;
    rules = {
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
        };
      };
      systemd-resolved = {
        name = "systemd-resolved";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
        };
      };
      forbid-mozilla = {
        name = "Forbid *.mozilla.* domains that provide no user benefit";
        enabled = true;
        action = "deny";
        duration = "always";
        precedence = true;
        operator = {
          type = "regexp";
          sensitive = false;
          operand = "dest.host";
          data = ".*\.services\.mozilla\.com";
        };
      };
      firefox-allow-443 = {
        name = "Allow Firefox connections to port 443";
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
              data = firefoxBin;
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "443";
            }
          ];
        };
      };
      firefox-forbid-80 = {
        name = "Deny Firefox connections to port 80";
        enabled = true;
        action = "deny";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            {
              type = "regexp";
              operand = "process.path";
              data = firefoxBin;
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "80";
            }
          ];
        };
      };
      git-remote-http = {
        name = "Allow git-remote-http";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.git}/libexec/git-core/git-remote-http";
        };
      };
      nix = {
        name = "Allow nix";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.nix}/bin/nix";
        };
      };
      mosh-client = {
        name = "Allow mosh-client to local network on UDP ports 60000-60100";
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
      perl-ssh = {
        name = "Allow perl SSH to local network on TCP port 22";
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
    };
  };
}
