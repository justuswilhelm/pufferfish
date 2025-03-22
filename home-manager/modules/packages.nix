{ pkgs, ... }:
let
  valeWithStyles = pkgs.vale.withStyles (s: [
    s.alex
    s.google
    s.microsoft
    s.proselint
    s.write-good
    s.readability
  ]);
in
{
  nixpkgs.overlays = [
    (final: previous: {
      vale-ls = previous.symlinkJoin {
        name = "vale-ls-with-styles-${previous.vale-ls.version}";
        paths = [ previous.vale-ls valeWithStyles ];
        nativeBuildInputs = [ previous.makeBinaryWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/vale-ls" \
            --set VALE_STYLES_PATH "$out/share/vale/styles/"
        '';
        meta = {
          inherit (previous.vale-ls.meta) mainProgram;
        };
      };
    })
  ];
  home.packages = [
    # Databases
    pkgs.sqlite

    # File, media conversion, Graphics stuff
    pkgs.pandoc
    pkgs.texliveTeTeX
    pkgs.graphviz
    pkgs.imagemagick

    # Networking
    pkgs.httperf
    pkgs.netcat-gnu
    pkgs.whois

    # WWW
    pkgs.httrack
    pkgs.curl
    pkgs.wget

    # File transfers, Backups
    pkgs.rsync
    pkgs.unison

    # Linters, Formatters, Spellcheckers
    # Removed en-science because it was marked unfree in nixpkgs 24.11
    (pkgs.aspellWithDicts (ds: with ds; [ en en-computers ]))
    (pkgs.hunspellWithDicts [ pkgs.hunspellDicts.en-us ])
    valeWithStyles
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.prettier
    pkgs.ruff

    # Build tools
    pkgs.cmake
    pkgs.hugo

    # Debugger
    pkgs.qemu

    # Compilers, Interpreters, VMs
    pkgs.poetry
    pkgs.jq
    pkgs.miller
    pkgs.nodejs_20
    pkgs.go
    pkgs.j

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
    pkgs.xz

    # Text tools
    pkgs.silver-searcher
    pkgs.ripgrep
    pkgs.fd
    pkgs.gnused
    pkgs.lnav

    # Core tools
    pkgs.coreutils
    pkgs.moreutils

    # Nix
    pkgs.nix-index
  ];
}
