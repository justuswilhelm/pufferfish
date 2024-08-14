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
    pkgs.nmap
    pkgs.wget
    pkgs.whois

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
          pkgs.radare2
          pkgs.meson
          pkgs.ninja
        ];
      }
    )
    # For hex overflow calc
    pkgs.programmer-calculator

    # InfoSec
    pkgs.thc-hydra
    pkgs.sqlmap
    pkgs.gobuster
    pkgs.nikto

    # Interpreters
    pkgs.asdf-vm
    pkgs.python310
    pkgs.poetry
    pkgs.jq
    pkgs.miller
    pkgs.nodejs_20

    # TUIs
    pkgs.htop
    pkgs.fzf
    pkgs.htop
    # Broken,
    # https://github.com/NixOS/nixpkgs/issues/299091
    pkgs.ncdu
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

    # Core tools
    pkgs.silver-searcher
    pkgs.ripgrep
    pkgs.fd
    pkgs.gnused
    pkgs.gnutar
    pkgs.coreutils
    pkgs.moreutils

    # Nix
    pkgs.nix-index
  ];
}
