{ lib, pkgs, config, options, ... }:
{
  imports = [
    ./modules/paths.nix
    ./modules/fonts.nix
    ./modules/pdb.nix
    ./modules/ssh.nix
    ./modules/man.nix
    ./modules/gpg.nix
    ./module/direnv.nix
    ./module/poetry.nix

    ./git.nix
    ./tmux.nix
    ./cmus.nix
    ./nvim.nix
    ./neomutt.nix
    ./packages.nix
    ./selenized.nix
    ./fish.nix
    ./asdf.nix
    ./passwordstore.nix
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
