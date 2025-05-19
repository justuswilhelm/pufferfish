# Modules used to debug networking
{ specialArgs, pkgs, ... }:
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
  ];
  programs.wireshark.enable = true;
  programs.tcpdump.enable = true;
  users.users.${specialArgs.name}.extraGroups = [
    # For tcpdump
    "pcap"
    # For wireshark
    "wireshark"
  ];
}
