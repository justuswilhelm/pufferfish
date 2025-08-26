# Modules used to debug networking
{ specialArgs, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    tcpdump
    ethtool
    arp-scan
    socat
    traceroute
    conntrack-tools
    # Just enabling wireshark wasn't enough
    wireshark

    kismet
  ];

  programs.traceroute.enable = true;
  programs.wireshark.enable = true;
  programs.tcpdump.enable = true;

  users.users.${specialArgs.name}.extraGroups = [
    # For tcpdump
    "pcap"
    # For wireshark
    "wireshark"
  ];

  services.opensnitch.rules = {
    traceroute-udp = {
      name = "Allow traceroute UDP";
      created = "1970-01-01T00:00:00Z";
      updated = "1970-01-01T00:00:00Z";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          { type = "simple"; operand = "process.path"; data = "${lib.getBin pkgs.traceroute}/bin/traceroute"; }
          { type = "simple"; operand = "protocol"; data = "udp"; }
        ];
      };
    };
    traceroute-udp6 = {
      name = "Allow traceroute UDP6";
      created = "1970-01-01T00:00:00Z";
      updated = "1970-01-01T00:00:00Z";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          { type = "simple"; operand = "process.path"; data = "${lib.getBin pkgs.traceroute}/bin/traceroute"; }
          { type = "simple"; operand = "protocol"; data = "udp6"; }
        ];
      };
    };
  };
}
