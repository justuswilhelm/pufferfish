{ lib, pkgs, config, options, ... }:
{
  imports = [
    ./modules/paths.nix
    ./modules/fonts.nix
    ./modules/pdb.nix
    ./modules/ssh.nix
    ./modules/man.nix

    ./git.nix
    ./tmux.nix
    ./cmus.nix
    ./nvim.nix
    ./neomutt.nix
    ./packages.nix
    ./selenized.nix
    ./gpg.nix
    ./fish.nix
    ./asdf.nix
    ./passwordstore.nix
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
