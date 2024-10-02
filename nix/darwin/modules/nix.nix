{ config, pkgs, ... }:
{
  environment.darwinConfig = "$HOME/.config/nix/darwin/darwin-configuration.nix";

  nix.nixPath = [
    {
      # TODO insert ${home}
      darwin-config = "$HOME/.config/nix/darwin/darwin-configuration.nix";
    }
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.settings = {
    auto-optimise-store = true;
    sandbox = false;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
}
