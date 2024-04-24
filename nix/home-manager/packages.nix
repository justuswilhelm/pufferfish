{ lib, isDebian, isDarwin, pkgs, extraPkgs }:
let
  aeroSpace = pkgs.stdenv.mkDerivation {
    pname = "aerospace";
    version = "0.8.6-Beta";
    nativeBuildInputs = [ pkgs.installShellFiles ];
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      cp bin/aerospace $out/bin
      installManPage manpage/*
    '';

    src = pkgs.fetchzip {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.8.6-Beta/AeroSpace-v0.8.6-Beta.zip";
      hash = "sha256-AUPaGUqydrMMEnNq6AvZEpdUblTYwS+X3iCygPFWWbQ=";
    };
  };
  debianOnly = lib.lists.optionals isDebian [
    # Compositor
    # This won't load because of some OpenGL issue
    # pkgs.sway
    # Swaylock doesn't work well.
    # pkgs.swaylock
    # Disabling this just to be safe
    # pkgs.swayidle
    pkgs.bemenu
    pkgs.grim
    pkgs.slurp

    # GUIs
    pkgs.keepassxc
    pkgs.firefox-esr
    pkgs.tor-browser

    # Debugger
    pkgs.gdb

    # Nix
    # Not available on Darwin
    pkgs.cntr
  ];
  darwinOnly = lib.lists.optionals isDarwin [
    aeroSpace
  ];
in
[
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
  pkgs.nmap
  pkgs.mitmproxy
  pkgs.wget
  pkgs.netcat-gnu
  pkgs.httperf

  # File transfers, Backups
  pkgs.rsync
  pkgs.unison

  # Linters, Formatters, Spellcheckers
  (pkgs.aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
  (pkgs.hunspellWithDicts [ pkgs.hunspellDicts.en-us ])
  pkgs.nixpkgs-fmt

  # Compilers
  pkgs.gcc

  # Debugger
  pkgs.qemu

  # Reverse engineering
  (
    pkgs.symlinkJoin {
      name = "ghidra";
      paths = [ pkgs.ghidra ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/ghidra --set _JAVA_AWT_WM_NONREPARENTING 1
      '';
    }
  )
  (
    pkgs.symlinkJoin {
      name = "radare2";
      paths = [
        extraPkgs.radare2
        pkgs.meson
        pkgs.ninja
      ];
    }
  )

  # Interpreters
  pkgs.asdf-vm
  pkgs.python310
  pkgs.poetry
  pkgs.jq
  pkgs.miller
  pkgs.nodejs_20
  # Begrudgingly adding this to stop nvim lspconfig complaining about it
  # missing. Possible workaround?
  # https://stackoverflow.com/questions/75397223/can-i-configure-nvim-lspconfig-to-fail-silently-rather-than-print-a-warning/76873612#76873612
  pkgs.nodePackages.pyright

  # TUIs
  pkgs.htop
  pkgs.fzf
  pkgs.htop
  # Broken,
  # https://github.com/NixOS/nixpkgs/issues/299091
  extraPkgs.ncdu
  pkgs.ncurses
  pkgs.neovim
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

  # Email
  (
    pkgs.symlinkJoin {
      name = "neomutt";
      paths = [ pkgs.neomutt ];
      buildInputs = [ pkgs.makeWrapper ];
      # https://neomutt.org/guide/reference.html#color-directcolor
      postBuild = ''
        wrapProgram $out/bin/neomutt --set TERM xterm-direct
      '';
    }
  )

  # Shell
  pkgs.fish
  pkgs.tmux
  pkgs.shellcheck
  pkgs.alacritty

  # Version control
  pkgs.git
  (
    pkgs.git-annex.overrideAttrs (
      previous: {
        # This implicitly strips away bup -- bup breaks the build.
        buildInputs = builtins.tail previous.buildInputs;
      }
    )
  )

  # Shell tools
  pkgs.cloc
  pkgs.fdupes
  pkgs.tree
  pkgs.watch
  pkgs.hyperfine
  pkgs.pv

  # Time tracking
  pkgs.timewarrior
  extraPkgs.pomoglorbo

  # Secrets
  pkgs.gnupg
  pkgs.pass

  # Core tools
  pkgs.silver-searcher
  pkgs.fd
  pkgs.gnused
  pkgs.gnutar
  pkgs.coreutils
  pkgs.moreutils

  # Nix
  pkgs.nix-index
]
++ debianOnly
++ darwinOnly
