{ ... }:
{
  networking.hostName = "nitrogen"; # Define your hostname.
  # Pick only one of the below networking options.
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
