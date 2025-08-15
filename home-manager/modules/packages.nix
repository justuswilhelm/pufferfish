{ pkgs, ... }:
{
  home.packages = [
    # Databases
    pkgs.sqlite

    # File, media conversion, Graphics stuff
    pkgs.graphviz
    pkgs.imagemagick

    # Networking
    pkgs.httperf
    pkgs.netcat-gnu
    pkgs.whois

    # File transfers, Backups
    pkgs.rsync

    # Linters, Formatters
    # Removed en-science because it was marked unfree in nixpkgs 24.11
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.prettier

    # Build tools
    pkgs.cmake
    pkgs.hugo

    # Compilers, Interpreters, VMs
    # TODO this could be part of modules/text-proc.nix
    pkgs.jq
    # TODO this could be part of modules/text-proc.nix
    pkgs.miller
    pkgs.nodejs_20
    pkgs.go
    pkgs.j

    # TUIs
    pkgs.htop
    pkgs.fzf
    pkgs.htop
    # Broken,
    # https://github.com/NixOS/nixpkgs/issues/299091
    # pkgs.ncdu
    pkgs.ncurses

    # Shell
    pkgs.shellcheck

    # Shell tools
    pkgs.cloc
    pkgs.fdupes
    pkgs.tree
    pkgs.watch
    pkgs.hyperfine
    pkgs.pv

    # Archive things
    pkgs.gnutar
    pkgs.unzip
    pkgs.p7zip
    pkgs.xz

    # TODO this could be part of modules/text-proc.nix
    # Text tools
    pkgs.silver-searcher
    pkgs.ripgrep
    pkgs.fd
    pkgs.gnused
    pkgs.lnav
    pkgs.datamash

    # Core tools
    pkgs.coreutils
    # pkgs.moreutils

    # Nix
    pkgs.nix-index
  ];
}
