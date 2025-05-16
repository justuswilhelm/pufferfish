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

    # TODO create modules/writing.nix
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
    # TODO unison still needed?
    pkgs.unison

    # Linters, Formatters, Spellcheckers
    # Removed en-science because it was marked unfree in nixpkgs 24.11
    (pkgs.aspellWithDicts (ds: with ds; [ en en-computers ]))
    (pkgs.hunspellWithDicts [ pkgs.hunspellDicts.en-us ])
    valeWithStyles
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.prettier
    # TODO move into modules/python.nix
    pkgs.ruff

    # Build tools
    pkgs.cmake
    pkgs.hugo

    # Debugger
    pkgs.qemu

    # Compilers, Interpreters, VMs
    # TODO this is already part of modules/poetry.nix
    pkgs.poetry
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

    # TODO move to modules/business.nix
    # Business
    pkgs.hledger

    # TODO unify with vdirsyncer config
    # "Business tools"
    pkgs.khal
    pkgs.khard

    # Shell
    # TODO might not be needed because we have
    # modules/fish.nix
    pkgs.fish
    # TODO might not be needed because we have
    # modules/tmux.nix
    pkgs.tmux
    pkgs.shellcheck

    # Shell tools
    pkgs.cloc
    pkgs.fdupes
    pkgs.tree
    pkgs.watch
    pkgs.hyperfine
    pkgs.pv
    # TODO make this part of modules/ssh.nix
    pkgs.mosh

    # Secrets
    pkgs.yubikey-manager

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
