# WLAN configuration for management and debugging
{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.wirelesstools
    pkgs.iw
    pkgs.aircrack-ng
  ];
}
