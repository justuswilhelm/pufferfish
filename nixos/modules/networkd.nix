{ ... }:
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
      "29-ignore-one-usb-eth" = {
        matchConfig = {
          Type = "ether";
          Path = [ "pci-0000:00:14.0-usb-0:3:2.0" ];
        };
        networkConfig = {
          DHCP = "no";
          DefaultRouteOnDevice = false;
          MulticastDNS = "no";
          Address = [
          ];
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
          Address = [
            # Private testing segment
            "10.128.0.10/24"
            # TP-Link
            "192.168.0.10/24"
            # Buffalo
            "192.168.11.10/24"
          ];
        };
        routes = [
          # Private testing segment
          {
            Source = "10.128.0.10/24";
            Destination = "10.128.0.1/24";
            Scope = "link";
          }
          # TP Link segment
          {
            Source = "192.168.0.10/24";
            Destination = "192.168.0.1/24";
            Scope = "link";
          }
          # Buffalo default segment
          {
            Source = "192.168.11.10/24";
            Destination = "192.168.11.1/24";
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
    extraConfig = ''
      DNSStubListener = udp
    '';
  };
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [
    # mDNS
    5353
  ];
}
