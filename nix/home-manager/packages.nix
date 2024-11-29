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
    pkgs.ruff

    # Build tools
    pkgs.cmake

    # Debugger
    pkgs.qemu

    # Interpreters, VMs
    pkgs.poetry
    pkgs.jq
    pkgs.miller
    pkgs.nodejs_20
    pkgs.openjdk

    # Python
    pkgs.pipx

    # Rust
    # If pkgs.gcc is in the env as well, bad things happen with libiconv
    # and other macOS available binaries.
    pkgs.rustup

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

    # "Business tools"
    pkgs.khal
    pkgs.khard

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
    pkgs.yubikey-manager

    # Archive things
    pkgs.gnutar
    pkgs.unzip
    pkgs.p7zip

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
