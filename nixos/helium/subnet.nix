# Configuration used for testing devices
{ ... }:
let
  ifname = "enp0s20f0u2";
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
          Path = [ "pci-*-usb-*" ];
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

  # services.dnsmasq = {
  #   enable = true;
  #   settings = {
  #     log-debug = true;
  #     interface = ifname;
  #     bind-interfaces = true;

  #     # DHCP config
  #     dhcp-range = "10.128.0.11,10.128.0.100,24h";
  #     dhcp-option = [
  #       "option:netmask,255.255.255.0"
  #       "option:router,10.128.0.10"
  #       "option:dns-server,10.128.0.10"
  #     ];

  #     # DNS
  #     server = [ "10.0.48.1" ];
  #     domain = "10.128.0.1/24";
  #   };
  # };
  # networking.nat = {
  #   enable = true;
  #   internalInterfaces = [ ifname ];
  #   externalInterface = extIfname;
  # };
  boot.kernel.sysctl = {
    # "net.ipv4.conf.all.forwarding" = 1;
    # "net.ipv4.conf.default.forwarding" = 1;
    "net.ipv4.conf.${extIfname}.route_localnet" = 1;
    "net.ipv4.conf.${ifname}.route_localnet" = 1;
    "net.ipv4.ip_forward" = 1;
  };
  networking.nftables.enable = true;
  # iifname "${ifname}" tcp dport 443 counter redirect to :9900
  # log level debug
  # meta nftrace set 1
  # Original:
  # table ip nixos-nat {
  #         chain pre {
  #                 type nat hook prerouting priority dstnat; policy accept;
  #         }
  #
  #         chain post {
  #                 type nat hook postrouting priority srcnat; policy accept;
  #                 iifname "enp0s20f0u6" oifname "enp7s0" masquerade comment "from internal interfaces"
  #         }
  #
  #         chain out {
  #                 type nat hook output priority mangle; policy accept;
  #         }
  # }
  #iifname "${ifname}" oifname "${extIfname}" masquerade
  networking.nftables.ruleset = ''
    table nat {
      chain prerouting {
        type nat hook prerouting priority dstnat;
        iifname "${ifname}" tcp dport 443 counter redirect to :9900
        log
      }
      chain postrouting {
        type nat hook postrouting priority srcnat;
        iifname "${ifname}" oifname "${extIfname}" counter masquerade comment "from internal interfaces"
      }
    }
  '';
  networking.firewall.logRefusedPackets = true;
  networking.firewall.logRefusedConnections = true;
  # https://github.com/aapooksman/certmitm?tab=readme-ov-file#usage
  # networking.firewall.extraCommands = ''
  #   iptables --table nat --append PREROUTING --in-interface ${ifname} --protocol tcp --match tcp --destination-port 443 --jump REDIRECT --to-ports 9900
  #   # iptables --table nat --append POSTROUTING --out-interface ${ifname} --jump MASQUERADE
  # '';
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
