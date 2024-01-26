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
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages =
    let
      debianOnly = lib.lists.optionals isDebian [
        # Terminal
        # TODO make me a home manager program
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
    let
      debianOnly = lib.lists.optionals isDebian [
        # TODO symlink me as config file
        (linkScript "${dotfiles}/pypoetry" "${xdgConfigHome}")
        # TODO symlink me as config file
        (linkScript "${dotfiles}/foot" "${xdgConfigHome}")
        # TODO symlink me as config file
        (linkScript "${dotfiles}/sway" "${xdgConfigHome}")
        # TODO symlink me as config file
        (linkScript "${dotfiles}/i3status" "${xdgConfigHome}")
        # TODO symlink me as config file
        (linkScript "${dotfiles}/x" "${xdgConfigHome}")
        # TODO symlink me as config file
        (linkScript "${dotfiles}/x/Xresources" "${xdgConfigHome}/.Xresources")
        # TODO symlink me as config file
        (linkScript "${dotfiles}/x/Xresources" "${xdgConfigHome}/.Xdefaults")
        # TODO symlink me as config file
        (linkScript "${dotfiles}/gdb" "${xdgConfigHome}")
      ];
      darwinOnly = lib.lists.optionals isDarwin [
        # TODO symlink me as config file
        (linkScript "${dotfiles}/pypoetry" "${applicationSupport}")
      ];
      shared = [
        # TODO symlink me as data file
        (linkScript "${dotfiles}/fonts" "${xdgDataHome}")
      ];
      links = debianOnly ++ darwinOnly ++ shared;
    in
    {
      performNvimUpdate = lib.hm.dag.entryAfter [ "links" ] ''
        export PATH=${pkgs.git}/bin:$PATH
        $DRY_RUN_CMD exec ${pkgs.neovim}/bin/nvim \
          --headless \
          +"PlugInstall --sync" +qa
      '';
    }
    // (lib.hm.dag.entriesAfter "links" [ "writeBoundary" ] links)
  ;

  home.stateVersion = "23.11";

  home.sessionPath = [
    "${dotfiles}/bin"
  ];

  home.sessionVariables = {
    DOTFILES = dotfiles;
    XDG_CONFIG_HOME = xdgConfigHome;
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

  programs.fish =
    let
      debianConfig = ''
        # for ssh-agent
        # Need XDG_RUNTIME_DIR, which is not present over SSH
        if [ -n $XDG_RUNTIME_DIR ]
            set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent
            if [ ! -e $SSH_AUTH_SOCK ]
                echo "Could not find $SSH_AUTH_SOCK" >&2
            end
        end
      '';
    in
    {
      enable = true;
      loginShellInit =
        if isDebian then ''
          # Only need to source this once
          source /nix/var/nix/profiles/default/etc/profile.d/nix.fish

          # We always want to enable wayland in moz, since we start sway through the terminal
          set -x MOZ_ENABLE_WAYLAND 1

          # If running from tty1 start sway
          set TTY1 (tty)

          if [ $TTY1 = /dev/tty1 ]
              exec sway
          end
        '' else "";
      interactiveShellInit = ''
        # Theme
        # =====
        # TODO make this selenized
        fish_config theme choose "Solarized Light"
        ${if isDebian then debianConfig else ""}'';
      shellAbbrs = {
        # Fish abbreviations
        # ------------------
        # Reload fish session. Useful if config.fish has changed.
        reload = "exec fish";

        # File abbreviations
        # ------------------
        # Ls shortcut with color, humanized, list-based output
        l = "ls -lhaG";

        # Git abbreviations
        # -----------------
        # Stage changed files in git index
        ga = "git add";
        # Stage changes in files in patch mode
        gap = "git add -p";
        # Check out a branch or file
        gc = "git checkout";
        # Check out a new branch
        gcb = "git checkout -b";
        # Cherry pick
        gcp = "git cherry-pick";
        # Abort cherry pick
        gcpa = "cherry-pick --abort";
        # Continue cherry picking
        gcpc = "git cherry-pick --continue";
        # Show the current diff for unstaged changes
        gd = "git diff";
        # Show the current diff for staged changes
        gdc = "git diff --cached";
        # Show commit statistics for staged changes
        gds = "git diff --shortstat --cached";
        # Fetch from default remote branch
        gf = "git fetch";
        # Fetch from all remote branches
        gfa = "git fetch --all";
        # Initialize an empty repository
        gi = "git init; and git commit --allow-empty -m 'nitial commit'";
        # Show the git log
        gl = "git log";
        # Show the git log in patch mode
        glp = "git log -p";
        # Commit the current staged changes
        gm = "git commit";
        # Amend to the previous commit
        gma = "git commit --amend";
        # Commit the current staged changes with a message
        gmm = "git commit -e -m";
        # Push to remote
        gp = "git push";
        # Push to remote and force update (potentially dangerous)
        gpf = "git push --force";
        # Bring current branch up to date with a rebase
        gpr = "git pull --rebase";
        # Push and create branch if it has not yet been created remotely
        gpu = "git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)";
        # Show remote repositories
        gr = "git remote";
        # Abort a rebase
        gra = "git rebase --abort";
        # Continue with the next rebase step
        grc = "git rebase --continue";
        # Perform interactive rebase
        gri = "git rebase -i";
        # Perform interactive rebase on origin/master
        grio = "git rebase -i origin/master";
        # Perform interactive rebase on origin/main
        griom = "git rebase -i origin/main";
        # Perform interactive rebase on origin/development
        griod = "git rebase -i origin/development";
        # Rebase current branch from origin/master
        gro = "git fetch --all; and git rebase origin/master";
        # Rebase current branch from origin/development
        grod = "git fetch --all; and git rebase origin/development";
        # Reset current branch to origin master (dangerous)
        groh = "git reset origin/master --hard";
        # Rebase current branch from origin/master
        grom = "git fetch --all; and git rebase origin/main";
        # Show current status
        gs = "git status";

        # Neovim abbreviations
        # --------------------
        # Start neovim
        e = "nvim";
      };
    };

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

  services.ssh-agent.enable = isDebian;
}
