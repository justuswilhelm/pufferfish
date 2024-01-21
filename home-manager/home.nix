{ lib, pkgs, specialArgs, ... }:
let
  selenized = (import ./selenized.nix) {inherit lib;};
  isDebian = specialArgs.system == "debian";
  isDarwin = specialArgs.system == "darwin";
  username = "justusperlwitz";
  homeDirectory = "${specialArgs.homeBaseDirectory}/${username}";
  dotfiles = "${homeDirectory}/.dotfiles";
  xdgConfigHome = "${homeDirectory}/.config";
  xdgDataHome = "${homeDirectory}/.local/share";
  applicationSupport = "${homeDirectory}/Library/Application Support";
  linkScript = from: to:
    ''
    if [ -a "${from}" ]
    then
      [ -n "$VERBOSE_ARG" ] && echo "Found source ${from}"
      $DRY_RUN_CMD ln --force --symbolic $VERBOSE_ARG "${from}" "${to}"
    else
      [ -n "$VERBOSE_ARG" ] && echo "Could not find ${from}"
      exit 1
    fi
    '';
in {
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = let
    debianOnly = lib.lists.optionals isDebian [
      # Terminal
      pkgs.foot

      # Compositor
      pkgs.i3status
      # This won't load because of some OpenGL issue
      # pkgs.sway
      # Swaylock doesn't work well.
      # pkgs.swaylock
      # Disabling this just to be safe
      # pkgs.swayidle

      # GUIs
      pkgs.keepassxc
    ];
    darwinOnly = lib.lists.optionals isDarwin [
    pkgs.openjdk17
    ]; in
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

    # Spellchecking
    pkgs.aspell
    pkgs.aspellDicts.en

    # Compilers
    pkgs.gcc

    # Debugger
    pkgs.gdb
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
    pkgs.timewarrior
    pkgs.tree
    pkgs.watch

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
  ++ darwinOnly;

  home.activation = let
    debianOnly = lib.lists.optionals isDebian [
      (linkScript "${dotfiles}/pypoetry" "${xdgConfigHome}")
      (linkScript "${dotfiles}/foot" "${xdgConfigHome}")
      (linkScript "${dotfiles}/sway" "${xdgConfigHome}")
      (linkScript "${dotfiles}/i3status" "${xdgConfigHome}")
      (linkScript "${dotfiles}/home-manager" "${xdgConfigHome}")
      (linkScript "${dotfiles}/systemd" "${xdgConfigHome}")
      (linkScript "${dotfiles}/x" "${xdgConfigHome}")
      (linkScript "${dotfiles}/x/Xresources" "${xdgConfigHome}/.Xresources")
      (linkScript "${dotfiles}/x/Xresources" "${xdgConfigHome}/.Xdefaults")
    ];
    darwinOnly = lib.lists.optionals isDarwin [
      (linkScript "${dotfiles}/pypoetry" "${applicationSupport}")
      (linkScript "${dotfiles}/karabiner" "${xdgConfigHome}")
      (linkScript "${dotfiles}/neomutt" "${xdgConfigHome}")
      (linkScript "${dotfiles}/offlineimap" "${xdgConfigHome}")
    ];
    shared = [
      (linkScript "${dotfiles}/nvim" "${xdgConfigHome}")
      (linkScript "${dotfiles}/git" "${xdgConfigHome}")
      (linkScript "${dotfiles}/pomoglorbo" "${xdgConfigHome}")
      (linkScript "${dotfiles}/nixpkgs" "${xdgConfigHome}")
      (linkScript "${dotfiles}/nix" "${xdgConfigHome}")
      (linkScript "${dotfiles}/fonts" "${xdgDataHome}")
      (linkScript "${dotfiles}/tmux" "${xdgConfigHome}")
      (linkScript "${dotfiles}/gdb" "${xdgConfigHome}")
    ];
    links = debianOnly ++ darwinOnly ++ shared;
  in
    {
      performNvimUpdate = lib.hm.dag.entryAfter ["links"] ''
        export PATH=${pkgs.git}/bin:$PATH
        $DRY_RUN_CMD exec ${pkgs.neovim}/bin/nvim \
          --headless \
          +"PlugInstall --sync" +qa
      '';
    }
    // (lib.hm.dag.entriesAfter "links" ["writeBoundary"] links)
  ;

  home.stateVersion = "23.11";

  xdg.configFile = {
    fishAsdfVm = {
      target = "fish/conf.d/asdf.fish";
      text = ''
      set -x ASDF_DIR ${pkgs.asdf-vm}/share/asdf-vm
      source ${pkgs.asdf-vm}/share/asdf-vm/asdf.fish
      '';
    };
    # Workaround for LANG issue
    # https://github.com/nix-community/home-manager/issues/354#issuecomment-475803163
    fishSession = {
      enable = isDebian;
      target = "${xdgConfigHome}/fish/conf.d/nix-session.fish";
      text = "set -x LOCALE_ARCHIVE ${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
    neomuttColors = {
      text = selenized.neomutt;
      target = "neomutt/colors";
    };
    neomuttMailcap = {
      text =
      let
        convert = pkgs.writeShellApplication {
          name = "convert";
          runtimeInputs = with pkgs; [ pandoc libuchardet ];
          text = ''
          format="$(uchardet "$1")"
          if [ "$format" = "unknown" ]; then
            format="utf-8"
          fi
          iconv -f "$format" -t utf-8 "$1" | pandoc -f html -t plain -
          '';
        };
      in
        ''
        text/html; ${convert}/bin/convert %s; copiousoutput
        '';
      target = "neomutt/mailcap";
    };
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
