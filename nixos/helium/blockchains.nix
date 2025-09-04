# Install software needed to interact with blockchains
{ lib, config, ... }:
{
  services.bitcoind.default = {
    enable = true;
  };

  fileSystems."/var/lib/bitcoind-default" =
    {
      device = "/dev/disk/by-uuid/37aab34d-9b1b-49d2-b77f-de9cf217f929";
      fsType = "ext4";
    };
  services.borgmatic.extra_exclude_patterns = [ "/var/lib/bitcoind-default" ];

  services.opensnitch = {
    enable = true;
    rules =
      let
        processPath = { type = "simple"; operand = "process.path"; data = "${lib.getBin config.services.bitcoind.default.package}/bin/bitcoind"; };
      in
      {
        "000-bitcoind-allowlist" = {
          name = "allow-bitcoind-allowlist";
          description = "bitcoind TCP to specific ports";
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
              { type = "simple"; operand = "protocol"; data = "tcp"; }
              { type = "regexp"; operand = "dest.port"; data = "^(8333|8335|30034|39388|20008)$"; }
            ];
          };
        };
        "001-bitcoind-deny-rest" = {
          name = "reject-bitcoind-deny-rest";
          description = "Deny all other bitcoind connections";
          created = "1970-01-01T00:00:00Z";
          updated = "1970-01-01T00:00:00Z";
          enabled = true;
          action = "reject";
          duration = "always";
          operator = processPath;
        };
      };
  };
}
