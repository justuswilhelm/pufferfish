{ ... }:
{
  networking.hostName = "nitrogen"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.environmentFile = "/run/secrets/wireless.env";
  networking.wireless.networks = {
    "@HOME_SSID@".psk = "@HOME_PSK@";
  };
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
