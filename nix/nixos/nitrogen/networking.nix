{ ... }:
{
  networking.hostName = "nitrogen"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.secretsFile = "/etc/wireless-credentials/wireless.env";
  networking.wireless.networks = {
    "ext:HOME_SSID".pskRaw = "ext:HOME_PSK";
  };
  networking.firewall.enable = true;

  # Hardcode lithium.local ip because mdns does not work... :(
  networking.hosts = {
    "10.0.57.235" = [ "lithium.local" ];
  };
}
