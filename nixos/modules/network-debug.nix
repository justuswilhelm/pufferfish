# Modules used to debug networking
{ specialArgs, pkgs, ... } :
{
  environment.systemPackages = with pkgs; [
    # For debugging
    tcpdump
    ethtool
    arp-scan
    # Just enabling wireshark wasn't enough
    wireshark
  ];
  programs.wireshark.enable = true;
  programs.tcpdump.enable = true;
  users.users.${specialArgs.name}.extraGroups = [
    # For tcpdump
    "pcap"
    # For wireshark
    "dumpcap"
  ];
}
