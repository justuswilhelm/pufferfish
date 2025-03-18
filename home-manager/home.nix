{ lib, pkgs, config, options, ... }:
{
  imports = [
    ./modules/direnv.nix
    ./modules/fonts.nix
    ./modules/gpg.nix
    ./modules/man.nix
    ./modules/paths.nix
    ./modules/pdb.nix
    ./modules/poetry.nix
    ./modules/ssh.nix

    # TODO these should be in ./module
    ./asdf.nix
    ./cmus.nix
    ./fish.nix
    ./git.nix
    ./neomutt.nix
    ./nvim.nix
    ./packages.nix
    ./passwordstore.nix
    ./selenized.nix
    ./tmux.nix
  ];
}
