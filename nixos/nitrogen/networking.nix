{ ... }:
{
  networking.interfaces.enp0s31f6.wakeOnLan.enable = false;

  systemd.network = {
    enable = true;
    networks = {
      "00-usb-wifi" = {
        matchConfig = {
          Path = "pci-0000:00:14.0-usb-*";
          Type = "wlan";
        };
        linkConfig = {
          Unmanaged = "yes";
        };
      };
    };
  };

  networking.wireless.interfaces = [ "wlp59s0" ];
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.secretsFile = "/etc/wireless-credentials/wireless.env";
  networking.wireless.networks = {
    "home sweet home".pskRaw = "ext:HOME_PSK";
    "boron".pskRaw = "ext:BORON_PSK";
  };
  networking.wireless.userControlled.enable = true;

  networking.firewall.logRefusedPackets = true;
  networking.firewall.logRefusedConnections = true;
  systemd.network.wait-online.enable = false;
}
