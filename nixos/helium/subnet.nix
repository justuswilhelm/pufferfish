# Configuration used for testing devices
{ ... }:
{
  systemd.network = {
    networks = {
      # Ignore a specific usb ethernet interface and don't configure it at
      # all.
      # Maybe have to adjust the PCI path here
      "29-ignore-one-usb-eth" = {
        matchConfig = {
          Type = "ether";
          Path = [ "pci-0000:00:14.0-usb-0:3:2.0" ];
        };
        networkConfig = {
          DHCP = "no";
          DefaultRouteOnDevice = false;
          MulticastDNS = "no";
          Address = [ ];
        };
        routes = [
        ];
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
          IPv4Forwarding = true;
          IPv6Forwarding = true;
          Address = [
            # Private testing segment
            "10.128.0.10/24"
          ];
        };
        routes = [
          # Private testing segment
          {
            Source = "10.128.0.10/24";
            Destination = "10.128.0.1/24";
            Scope = "link";
          }
          # Default route to internet
          {
            Gateway = "10.0.48.1";
            Destination = "0.0.0.0/0";
          }
        ];
      };
    };
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      log-debug = true;
      interface = "enp0s20f0u6";
      bind-interfaces = true;

      # DHCP config
      dhcp-range = "10.128.0.11,10.128.0.100,24h";
      dhcp-option = [
        "option:netmask,255.255.255.0"
        "option:router,10.128.0.10"
        "option:dns-server,10.128.0.10"
      ];

      # DNS
      server = [ "10.0.48.1" ];
      domain = "10.128.0.1/24";
    };
  };
  networking.firewall.allowedUDPPorts = [
    # bootps
    67
  ];
}
