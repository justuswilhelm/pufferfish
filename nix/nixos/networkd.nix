{ ... }:
{
  # systemd networkd and resolved config
  systemd.network = {
    enable = true;
    networks = {
      "10-ethernet" = {
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
}
