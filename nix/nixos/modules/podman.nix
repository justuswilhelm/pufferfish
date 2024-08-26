{ pkgs, ... } :
{
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.dive
    pkgs.podman-tui
    pkgs.podman-compose
    pkgs.skopeo
  ];
}
