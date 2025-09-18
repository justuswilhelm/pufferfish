{ lib, pkgs, config, ... }:
{
  services.tor = {
    enable = true;
    openFirewall = true;
  };

  # OpenSnitch rule allowing tor to connect to port 993 as user 35 for 12h
  services.opensnitch.rules = {
    allow-tor-993 = {
      name = "allow-12h-list-nixstoreih1fgmdrbqc1cp5ljpfyc1k2nx84asgp-tor-04816bintor-993-35";
      created = "2025-09-18T13:17:51.000000Z";
      enabled = true;
      action = "allow";
      duration = "12h";
      operator = {
        type = "list";
        operand = "list";
        list = [
          { type = "regexp"; operand = "dest.port"; data = "^(993|8080|9001)$"; }
          { type = "simple"; operand = "user.name"; data = "tor"; }
          { type = "simple"; operand = "protocol"; data = "tcp"; }
          { type = "simple"; operand = "process.path"; data = "${lib.getBin pkgs.tor}/bin/tor"; }
        ];
      };
    };
  };
}
