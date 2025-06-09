# Install software needed to interact with blockchains
{ lib, config, ... }:
{
  services.bitcoind.default = {
    enable = true;
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
