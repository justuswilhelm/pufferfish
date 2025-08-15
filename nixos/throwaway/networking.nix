{ ... }:
{
  networking.wireless.userControlled.enable = true;

  systemd.network.wait-online.enable = false;
}
