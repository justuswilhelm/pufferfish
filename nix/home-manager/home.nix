{ lib, pkgs, specialArgs, ... }:
let
  selenized = (import ./selenized.nix) { inherit lib; };
  isDebian = specialArgs.system == "debian";
  isDarwin = specialArgs.system == "darwin";
  username = "justusperlwitz";
  homeDirectory = "${specialArgs.homeBaseDirectory}/${username}";
  dotfiles = "${homeDirectory}/.dotfiles";
  xdgConfigHome = "${homeDirectory}/.config";
  xdgDataHome = "${homeDirectory}/.local/share";
  # TODO Add xdgCacheHome here
  applicationSupport = "${homeDirectory}/Library/Application Support";
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages =
    let
      debianOnly = lib.lists.optionals isDebian [
        # Compositor
        # This won't load because of some OpenGL issue
        # pkgs.sway
        # Swaylock doesn't work well.
        # pkgs.swaylock
        # Disabling this just to be safe
        # pkgs.swayidle

        # GUIs
        pkgs.keepassxc

        # Debugger
        pkgs.gdb
      ];
      darwinOnly = lib.lists.optionals isDarwin [
        pkgs.openjdk17
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

      # Time tracking
      pkgs.timewarrior
      specialArgs.pomoglorbo

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

  home.activation =
    {
      performNvimUpdate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH=${pkgs.git}/bin:$PATH
        $DRY_RUN_CMD exec ${pkgs.neovim}/bin/nvim \
          --headless \
          +"PlugInstall --sync" +qa
      '';
    };

  home.stateVersion = "23.11";

  home.sessionPath = [
    "${dotfiles}/bin"
  ];

  home.sessionVariables = {
    DOTFILES = dotfiles;
    XDG_CONFIG_HOME = xdgConfigHome;
    XDG_DATA_HOME = xdgDataHome;
    EDITOR = "${pkgs.neovim}/bin/nvim";
    NNN_OPENER = "file";
    PASSWORD_STORE_DIR = "${xdgDataHome}/pass";
    # Still needed?
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    # TODO split up time warrior conf and db
    TIMEWARRIORDB = "${xdgConfigHome}/timewarrior";
  } // (lib.attrsets.optionalAttrs isDebian {
    # Workaround for LANG issue
    # https://github.com/nix-community/home-manager/issues/354#issuecomment-475803163
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  });

  xdg.dataFile = {
    iosevka = {
      source = ../../fonts/iosevka-fixed-regular.ttf;
      target = "fonts/iosevka-fixed-regular.ttf";
    };
  };
  xdg.dataHome = xdgDataHome;

  xdg.configFile = (import ./xdgConfigFiles.nix) {
    inherit lib pkgs isDarwin isDebian homeDirectory;
  };
  # Pypoetry braucht ne extrawurst fuer xdg_config_home lol
  home.file = {
    pyPoetryDarwin = {
      enable = isDarwin;
      text = ''
        cache-dir = "${homeDirectory}/Library/Caches"
      '';
      target = "${applicationSupport}/pypoetry/config.toml";
    };
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ../../tmux/tmux.conf}
      ${selenized.tmux}
    '';
    # Set longer scrollback buffer
    historyLimit = 500000;
    # Escape time, for vi
    escapeTime = 10;
    # Mouse input
    mouse = true;
    # vi navigation in tmux screens
    keyMode = "vi";
    # Best compability for true color
    terminal = "screen-256color";
  };
  programs.fish = (import ./fish.nix) { inherit isDebian; };

  programs.git = {
    enable = true;
    # TODO try these out
    # difftastic = { enable = true; };
    # delta = { enable = true; };
    extraConfig = {
      pull = {
        rebase = true;
      };
      rebase = {
        autostash = true;
      };
      commit = {
        verbose = true;
      };
      init = {
        defaultBranch = "main";

      };
      diff = {
        tool = "vimdiff";
      };
      "diff \"sqlite3\"" = {
        binary = true;
        # https://stackoverflow.com/questions/13271643/git-hook-for-diff-sqlite-table/21789167#21789167
        textconv = "echo .dump | sqlite3";
      };
      merge = {
        tool = "vimdiff";
      };
      "mergetool \"vimdiff\"" = {
        path = "nvim";
      };
      fetch = {
        prune = true;
      };
    };
    ignores =
      if isDarwin then [
        ".DS_Store"
      ] else [ ];
    includes = [
      {
        # Create something like this:
        # [user]
        # name = "My name"
        # email = "my@email.address";
        path = "${xdgConfigHome}/git/user";
      }
    ];
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_rsa
    '';
  };

  programs.foot = {
    enable = isDebian;
    settings = {
      main = {
        # Install foot-themes
        include = "${pkgs.foot.themes}/share/foot/themes/selenized-light";
        font = "Iosevka Fixed:size=11";
      };
    };
  };

  programs.i3status = {
    enable = isDebian;
    enableDefault = false;
    inherit (import ./i3status.nix) general modules;
  };

  services.ssh-agent.enable = isDebian;

  xresources = {
    properties = {
      # Dell U2720qm bought 2022 on Amazon Japan
      # Has physical width x height
      # 60.5 cm * 33.4 cm (approx)
      # and claims 27 inches with 4K resolution (3840 x 2160)
      # Which if we plug into
      # https://www.sven.de/dpi/
      # gives us
      "Xft.dpi" = 163;
    };
  };
}
