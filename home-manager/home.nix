{ lib, pkgs, config, options, ... }:
{
  imports = [
    ./modules/cmus.nix
    ./modules/paths.nix
    ./modules/fish.nix
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/neomutt.nix
    ./modules/nvim.nix
    ./modules/pdb.nix
    ./modules/selenized.nix
    ./modules/ssh.nix
    ./modules/tmux.nix
    ./modules/man.nix
    ./modules/gpg.nix
    ./modules/packages.nix
    ./modules/passwordstore.nix
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  programs.poetry = {
    enable = true;
    settings = {
      cache-dir = "${config.xdg.cacheHome}/pypoetry";
    };
  };

  # TODO separate module
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
