{ config, pkgs, ... }:
{
  nix.nixPath = [ "/nix/var/nix/profiles/per-user/root/channels" ];
  nix.extraOptions = ''
    experimental-features = flakes nix-command
  '';
  nix.settings = {
    sandbox = true;
    extra-sandbox-paths = [ "/nix/store" ];
  };
  nix.optimise.automatic = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
}
