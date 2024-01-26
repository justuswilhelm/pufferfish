{ lib, isDebian, isDarwin, pkgs, extraPkgs }:
let
  debianOnly = lib.lists.optionals isDebian [
    # Compositor
    # This won't load because of some OpenGL issue
    # pkgs.sway
    # Swaylock doesn't work well.
    # pkgs.swaylock
    # Disabling this just to be safe
    # pkgs.swayidle
    pkgs.alacritty

    # GUIs
    pkgs.keepassxc

    # Debugger
    pkgs.gdb
  ];
  darwinOnly = lib.lists.optionals isDarwin [
  ];
in
[
  # Databases
  pkgs.sqlite

  # Build tools
  pkgs.hugo

  # File conversion
  pkgs.pandoc

  # Media
  pkgs.imagemagick

  # Networking
  pkgs.curl
  pkgs.nmap
  pkgs.mitmproxy

  # File transfers, Backups
  pkgs.rsync
  pkgs.unison

  # Linters, Formatters, Spellcheckers
  (pkgs.aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
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
  pkgs.radare2

  # Interpreters
  pkgs.asdf-vm
  pkgs.python310
  pkgs.poetry
  pkgs.jq
  pkgs.miller

  # TUIs
  pkgs.htop
  pkgs.fzf
  pkgs.htop
  pkgs.ncdu
  pkgs.ncurses
  pkgs.neovim
  pkgs.nnn

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
