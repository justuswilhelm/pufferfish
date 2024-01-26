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

  xdg.configFile = {
    nixConfig = {
      text = ''
        experimental-features = nix-command flakes
      '';
      target = "nix/nix.conf";
    };
    fishAsdfVm = {
      target = "fish/conf.d/asdf.fish";
      text = ''
        set -x ASDF_DIR ${pkgs.asdf-vm}/share/asdf-vm
        source ${pkgs.asdf-vm}/share/asdf-vm/asdf.fish
      '';
    };
    fishFunctions = {
      target = "fish/functions";
      source = ../../fish/functions;
      recursive = true;
    };
    neomuttColors = {
      text = selenized.neomutt;
      target = "neomutt/colors";
    };
    neomuttShared = {
      source = ../../neomutt/shared;
      target = "neomutt/shared";
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
    nvimAfter = {
      source = ../../nvim/after;
      target = "nvim/after";
    };
    nvimSelenized = {
      source = ../../nvim/colors/selenized.vim;
      target = "nvim/colors/selenized.vim";
    };
    nvimInit = {
      source = ../../nvim/init.lua;
      target = "nvim/init.lua";
    };
    nvimInitBase = {
      source = ../../nvim/init_base.lua;
      target = "nvim/init_base.lua";
    };
    nvimPlug = {
      source = ../../nvim/autoload/plug.vim;
      target = "nvim/autoload/plug.vim";
    };
    nvimSnippets = {
      source = ../../nvim/snippets;
      target = "nvim/snippets";
    };
    pomoglorbo = {
      source = ../../pomoglorbo/config.ini;
      target = "pomoglorbo/config.ini";
    };
    cmusRc = {
      source = ../../cmus/rc;
      target = "cmus/rc";
    };
    karabiner = {
      enable = isDarwin;
      source = ../../karabiner/karabiner.json;
      target = "karabiner/karabiner.json";
    };
    sway = {
      enable = isDebian;
      source = ../../sway/config;
      target = "sway/config";
    };
    swayColors = {
      enable = isDebian;
      source = ../../sway/config.d/colors;
      target = "sway/config.d/colors";
    };
    pyPoetryDebian = {
      enable = isDebian;
      # We would like to use XDG_CACHE_HOME here
      text = ''
        cache-dir = "${homeDirectory}/.cache/pypoetry"
      '';
      target = "pypoetry/config.toml";
    };
    gdb = {
      enable = isDebian;
      source = ../../gdb/gdbinit;
      target = "gdb/gdbinit";
    };
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
    general =
      {
        output_format = "i3bar";
        interval = 5;
      };

    modules = {
      "ethernet enp7s0" = {
        settings = {
          format_up = "enp7s0: %ip (%speed)";
          format_down = "enp7s0: down";
        };
        position = 0;
      };

      "disk /" = {
        settings = {
          format = "/ %free";
        };
        position = 1;
      };

      "disk /home" = {
        settings = {
          format = "/home %free";
        };
        position = 2;
      };

      load = {
        settings = {
          format = "load: %1min, %5min, %15min";
        };
        position = 3;
      };

      memory = {
        settings = {
          format = "f: %free a: %available u: %used t: %total";
          threshold_degraded = "10%";
          format_degraded = "MEMORY: %free";
        };
        position = 4;
      };

      "tztime UTC" = {
        settings = {
          format = "UTC %Y-%m-%d %H:%M:%S";
          timezone = "UTC";
        };
        position = 5;
      };

      "tztime local" = {
        settings = {
          format = "LCL %Y-%m-%d %H:%M:%S %Z";
        };
        position = 6;
      };
    };
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
