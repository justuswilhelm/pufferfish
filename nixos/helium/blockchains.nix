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

  services.opensnitch = {
    enable = true;
    rules = {
      bitcoind = {
        name = "bitcoind";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin config.services.bitcoind.default.package}/bin/bitcoind";
        };
      };
    };
  };
}
