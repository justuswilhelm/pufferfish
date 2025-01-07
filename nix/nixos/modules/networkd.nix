{ pkgs, ... }:
{
  # systemd networkd and resolved config
  systemd.network = {
    enable = true;
    networks = {
      "10-ethernet" = {
        matchConfig = {
          # Prevent networkd from messing with libvirt bridges
          Name = "!vnet*";
          Type = "ether";
        };
        networkConfig = {
          DHCP = "yes";
          MulticastDNS = "yes";
        };
      };
      "20-wlan" = {
        matchConfig = {
          Type = "wlan";
        };
        networkConfig = {
          DHCP = "yes";
          MulticastDNS = "yes";
        };
      };
    };
  };
  networking.useNetworkd = true;
  services.resolved = {
    enable = true;
    domains = [ "~." ];
  };
  networking.firewall.allowedUDPPorts = [
    # mDNS
    5353
  ];
  environment.systemPackages = with pkgs; [
    # For debugging
    tcpdump
    ethtool
    wireshark
    arp-scan
  ];
}
