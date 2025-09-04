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
    rules = {
      forbid-mozilla = {
        name = "Forbid *.mozilla.* domains that provide no user benefit";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "reject";
        duration = "always";
        precedence = true;
        operator = {
          type = "regexp";
          sensitive = false;
          operand = "dest.host";
          data = "[^.]+\.services\.mozilla\.com";
        };
      };
      firefox-allow-443 = {
        name = "Allow Firefox connections to port 443";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "regexp"; operand = "process.path"; data = firefoxBin; }
            { type = "simple"; operand = "dest.port"; data = "443"; }
          ];
        };
      };
      firefox-allow-local-80 = {
        name = "Allow local Firefox connections to :80";
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
            { type = "regexp"; operand = "process.path"; data = firefoxBin; }
            { type = "simple"; operand = "dest.port"; data = "80"; }
            { type = "network"; operand = "dest.network"; data = "10.0.0.0/8"; }
          ];
        };
      };
      firefox-deny-80 = {
        name = "Deny Firefox connections to :80";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "reject";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "regexp"; operand = "process.path"; data = firefoxBin; }
            { type = "simple"; operand = "dest.port"; data = "80"; }
          ];
        };
      };
    };
  };
}
