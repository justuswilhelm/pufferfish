{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 51820 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
