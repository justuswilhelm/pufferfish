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
    };
  };
  networking.useNetworkd = true;
  services.resolved = {
    enable = true;
    # domains = [ "~." ];
    extraConfig = ''
      DNSStubListener = udp
    '';
    llmnr = "false";
  };
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [
    # mDNS
    5353
  ];
}
