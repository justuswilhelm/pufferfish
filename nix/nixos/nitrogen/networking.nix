{ ... }:
{
  networking.hostName = "nitrogen"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.environmentFile = "/etc/wireless-credentials/wireless.env";
  networking.wireless.networks = {
    "@HOME_SSID@".psk = "@HOME_PSK@";
  };
  networking.firewall.enable = true;

  # Hardcode lithium.local ip because mdns does not work... :(
  networking.hosts = {
    "10.0.57.235" = [ "lithium.local" ];
  };
}
