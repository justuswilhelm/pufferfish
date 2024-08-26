{ pkgs, ... }:
{
  # systemd networkd and resolved config
  systemd.network = {
    enable = true;
    networks = {
      "10-ethernet" = {
        matchConfig = {
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
  environment.systemPackages = with pkgs; [
    # For debugging
    tcpdump
    ethtool
    arp-scan
  ];
}
