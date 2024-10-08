{ pkgs, ... }:
{
  home.packages = [
    # Databases
    pkgs.sqlite

    # Build tools
    pkgs.hugo

    # File conversion
    pkgs.pandoc
    pkgs.texliveTeTeX

    # Media
    pkgs.imagemagick

    # Networking
    pkgs.curl
    pkgs.httperf
    pkgs.netcat-gnu
    pkgs.wget
    pkgs.whois

    # File transfers, Backups
    pkgs.rsync
    pkgs.unison

    # Linters, Formatters, Spellcheckers
    (pkgs.aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    (pkgs.hunspellWithDicts [ pkgs.hunspellDicts.en-us ])
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.prettier

    # Compilers
    pkgs.gcc

    # Debugger
    pkgs.qemu

    # Interpreters, VMs
    pkgs.poetry
    pkgs.jq
    pkgs.miller
    pkgs.nodejs_20
    pkgs.openjdk

    # TUIs
    pkgs.htop
    pkgs.fzf
    pkgs.htop
    # Broken,
    # https://github.com/NixOS/nixpkgs/issues/299091
    # pkgs.ncdu
    pkgs.ncurses
    (
      pkgs.symlinkJoin {
        name = "nnn";
        paths = [ pkgs.nnn pkgs.gnused ];
        postBuild = ''
          cp $out/bin/sed $out/bin/gsed
        '';
      }
    )

    # Business
    pkgs.hledger

    # Shell
    pkgs.fish
    pkgs.tmux
    pkgs.shellcheck

    # Version control
    pkgs.git
    pkgs.git-annex

    # Shell tools
    pkgs.cloc
    pkgs.fdupes
    pkgs.tree
    pkgs.watch
    pkgs.hyperfine
    pkgs.pv
    pkgs.mosh

    # Secrets
    pkgs.gnupg
    pkgs.pass
    pkgs.yubikey-manager

    # Archive things
    pkgs.gnutar
    pkgs.unzip

    # Core tools
    pkgs.silver-searcher
    pkgs.ripgrep
    pkgs.fd
    pkgs.gnused
    pkgs.coreutils
    pkgs.moreutils

    # Nix
    pkgs.nix-index
  ];
}
