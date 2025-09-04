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

  services.opensnitch.rules =
    let
      tracerouteProtocols = [ "udp" "udp6" "icmp" ];
      makeTracerouteRule = protocol: {
        name = "Allow traceroute ${protocol}";
        created = "1970-01-01T00:00:00Z";
        updated = "1970-01-01T00:00:00Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            { type = "regexp"; operand = "process.path"; data = "^${lib.getBin pkgs.traceroute}/bin/traceroute$|^traceroute$"; }
            { type = "simple"; operand = "protocol"; data = protocol; }
          ];
        };
      };
    in
    lib.listToAttrs (map (protocol: {
      name = "traceroute-${protocol}";
      value = makeTracerouteRule protocol;
    }) tracerouteProtocols);
}
