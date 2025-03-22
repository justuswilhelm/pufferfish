{ lib, pkgs, config, options, ... }:
{
  imports = [
    ./modules/cmus.nix
    ./modules/direnv.nix
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
    ./modules/poetry.nix
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
