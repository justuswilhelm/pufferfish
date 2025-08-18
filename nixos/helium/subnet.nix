# Configuration used for testing devices
{ ... }:
let
  ifname = "enp0s20f0u2c2";
  # Private testing segment
  privateSubnet = "10.128.0.10/24";
  privateSubnetGateway = "10.128.0.1/24";
  extIfname = "enp7s0";
  dnsServer = "10.0.48.1";
  router = "10.128.0.10";
in
{

  systemd.network = {
    networks = {
      "30-usb-ethernet" = {
        matchConfig = {
          Type = "ether";
          Driver = [ "cdc_ncm" ];
        };
        networkConfig = {
          DHCP = "no";
          DefaultRouteOnDevice = false;
          MulticastDNS = "no";
          IPv4Forwarding = true;
          IPv6Forwarding = true;
          Address = [ privateSubnet ];
        };
        routes = [
          # Private testing segment
          {
            Source = privateSubnet;
            Destination = privateSubnetGateway;
            Scope = "link";
          }
        ];
      };
    };
  };


  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [ ifname ];
      };
      lease-database = {
        name = "/var/lib/kea/dhcp4.lease";
        persist = true;
        type = "memfile";
      };
      rebind-timer = 2000;
      renew-timer = 1000;
      subnet4 = [
        {
          id = 1;
          pools = [
            {
              pool = "10.128.0.11 - 10.128.0.20";
            }
          ];
          subnet = privateSubnet;
          option-data = [
            {
              "name" = "routers";
              "code" = 3;
              # External network
              "data" = router;
              "csv-format" = true;
              "space" = "dhcp4";
            }
            {
              "name" = "domain-name-servers";
              "code" = 6;
              # External network
              "data" = dnsServer;
              "csv-format" = true;
              "space" = "dhcp4";
            }
          ];
        }
      ];
      valid-lifetime = 4000;
    };
  };
  boot.kernel.sysctl = {
    "net.ipv4.conf.${extIfname}.route_localnet" = 1;
    "net.ipv4.conf.${ifname}.route_localnet" = 1;
    "net.ipv4.ip_forward" = 1;
  };
  networking.nftables.enable = true;
  # https://github.com/aapooksman/certmitm?tab=readme-ov-file#usage
  # TODO block everything except for the following on the device:
  # icmp type echo-request accept comment "allow ping"
  # icmpv6 type != { nd-redirect, 139 } accept comment "Accept all ICMPv6 messages except redirects and node information queries (type 139).  See RFC 4890, section 4.4."

  # # HTTPS (443/tcp)
  # tcp dport 443 accept

  # # DNS (53/tcp, 53/udp)
  # tcp dport 53 accept
  # udp dport 53 accept

  # # NTP (123/udp)
  # udp dport 123 accept
  networking.nftables.ruleset = ''
    table nat {
      chain prerouting {
        type nat hook prerouting priority dstnat;
        iifname "${ifname}" tcp dport 443 counter redirect to :9900
      }
      chain postrouting {
        type nat hook postrouting priority srcnat;
        iifname "${ifname}" oifname "${extIfname}" counter masquerade comment "from internal interfaces"
      }
    }
  '';
  networking.firewall.logRefusedPackets = true;
  networking.firewall.logRefusedConnections = true;
  networking.firewall.interfaces.${ifname} = {
    allowedUDPPorts = [
      # dns
      53
      # bootps
      67
    ];
    allowedTCPPorts = [
      # TLS / certmitm
      9900
    ];
  };
}
