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
          Path = "pci-0000:0?:0?.0";
          Type = "ether";
        };
        networkConfig = {
          DHCP = "yes";
          MulticastDNS = "yes";
          LinkLocalAddressing = "no";
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
          Path = [ "pci-*-usb-*" ];
        };
        networkConfig = {
          DHCP = "no";
          DefaultRouteOnDevice = false;
          MulticastDNS = "no";
          Address = "10.128.0.10";
        };
        routes = [
          {
            Destination = "10.128.0.1/24";
            Scope = "link";
          }
        ];
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
    arp-scan
    # Just enabling wireshark wasn't enough
    wireshark
  ];
  programs.wireshark.enable = true;
}
