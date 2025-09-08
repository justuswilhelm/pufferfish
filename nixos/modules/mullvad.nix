# Mullvad configuration
{ config, lib, pkgs, specialArgs, ... }:
{
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  services.opensnitch.rules.mullvad-daemon = {
    name = "allow-mullvad-daemon";
    description = "Allow Mullvad daemon to connect to ipv4.am.i.mullvad.net on ports 443/53";
    created = "1970-01-01T00:00:00Z";
    updated = "1970-01-01T00:00:00Z";
    enabled = true;
    action = "allow";
    duration = "always";
    operator = {
      type = "list";
      operand = "list";
      list = [
        { type = "simple"; operand = "dest.host"; data = "ipv4.am.i.mullvad.net"; }
        { type = "regexp"; operand = "dest.port"; data = "^(443|53)$"; }
        { type = "simple"; operand = "user.id"; data = "0"; }
        { type = "simple"; operand = "process.path"; data = "${lib.getBin config.services.mullvad-vpn.package}/bin/.mullvad-daemon-wrapped"; }
      ];
    };
  };
}
