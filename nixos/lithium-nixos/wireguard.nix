{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 51820 51822 ];
  networking.firewall.allowedUDPPorts = [ 51820 51822 ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
