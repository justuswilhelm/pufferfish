{ pkgs, ... }:
{
  # systemd networkd and resolved config
  systemd.network = {
    enable = true;
    networks = {
      "10-ethernet" = {
        matchConfig = {
          # Prevent networkd from messing with libvirt bridges
          # Add more pci paths for other devices
          Path = "pci-0000:07:00.0";
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
          LinkLocalAddressing = "no";
        };
      };
      "30-usb-ethernet" = {
        matchConfig = {
          Type = "ether";
          Path = ["pci-*-usb-*"];
        };
        networkConfig = {
          DHCP = "yes";
          DefaultRouteOnDevice = false;
          MulticastDNS = "no";
        };
      };
    };
  };
  networking.useNetworkd = true;
  services.resolved = {
    enable = true;
    # domains = [ "~." ];
  };
  networking.firewall.enable = true;
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
