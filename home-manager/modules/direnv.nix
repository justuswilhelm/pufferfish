# Enable direnv and nix-direnv
{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
