{ lib, pkgs, config, options, ... }:
{
  imports = [
    ./modules/paths.nix
    ./modules/fonts.nix
    ./modules/pdb.nix
    ./modules/ssh.nix
    ./modules/man.nix
    ./modules/gpg.nix
    ./modules/direnv.nix
    ./modules/poetry.nix

    # TODO these should be in ./module
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
}
