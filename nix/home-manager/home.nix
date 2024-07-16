{ lib, pkgs, specialArgs, osConfig, ... }:
let
  selenized = (import ./selenized.nix) { inherit lib; };
  isDebian = specialArgs.system == "debian";
  isDarwin = specialArgs.system == "darwin";
  username = "justusperlwitz";
  homeDirectory = "${specialArgs.homeBaseDirectory}/${username}";
  dotfiles = "${homeDirectory}/.dotfiles";
  xdgConfigHome = "${homeDirectory}/.config";
  xdgDataHome = "${homeDirectory}/.local/share";
  xdgStateHome = "${homeDirectory}/.local/state";
  applicationSupport = "${homeDirectory}/Library/Application Support";
  xdgCacheHome =
    if isDebian then
      "${homeDirectory}/.cache" else "${homeDirectory}/Library/Caches";
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = import ./packages.nix {
    inherit lib isDebian isDarwin pkgs;
    extraPkgs = {
      inherit (specialArgs) pomoglorbo;
    };
  };

  home.activation =
    {
      performNvimUpdate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH=${pkgs.git}/bin:${pkgs.gcc}/bin:$PATH
        $DRY_RUN_CMD exec ${pkgs.neovim}/bin/nvim \
          --headless \
          +"PlugUpdate --sync" +qa
      '';
    };

  home.stateVersion = "24.05";

  home.sessionPath = [
    "${dotfiles}/bin"
  ];

  home.sessionVariables = {
    DOTFILES = dotfiles;
    XDG_CONFIG_HOME = xdgConfigHome;
    XDG_DATA_HOME = xdgDataHome;
    XDG_STATE_HOME = xdgStateHome;
    XDG_CACHE_HOME = xdgCacheHome;
    EDITOR = "${pkgs.neovim}/bin/nvim";
    NNN_OPENER = "open";
    PASSWORD_STORE_DIR = "${xdgDataHome}/pass";
    # XXX Still needed?
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  } // (lib.attrsets.optionalAttrs isDebian {
    # Workaround for LANG issue
    # https://github.com/nix-community/home-manager/issues/354#issuecomment-475803163
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    # We always want to enable wayland in moz, since we start sway through the terminal
    MOZ_ENABLE_WAYLAND = 1;
  });

  xdg.dataFile = {
    iosevka = {
      source = ../../fonts/iosevka-fixed-regular.ttf;
      target = "fonts/iosevka-fixed-regular.ttf";
    };
  };
  xdg.dataHome = xdgDataHome;

  xdg.configFile = (import ./xdgConfigFiles.nix) {
    inherit lib pkgs isDarwin isDebian homeDirectory xdgCacheHome;
  };
  home.file = {
    # Pypoetry braucht ne extrawurst fuer xdg_config_home lol
    pyPoetryDarwin = {
      enable = isDarwin;
      text = ''
        cache-dir = "${xdgCacheHome}/pypoetry"
      '';
      target = "${applicationSupport}/pypoetry/config.toml";
    };
    xbar = {
      enable = isDarwin;
      source = ../../xbar;
      target = "${applicationSupport}/xbar";
      recursive = true;
    };
    pdbrc =
      let
        pdbrcpy = pkgs.writeTextFile {
          name = "pdbrc.py";
          # Might want to create the following folder:
          # $HOME/.local/state/pdb/pdb_history
          text = ''
            import pdb
            def _pdbrc_init() -> None:
                import readline as r
                import pathlib
                from atexit import register
                history_d = pathlib.Path.home() / ".local/state/pdb"
                history_f = history_d / "pdb_history"
                if not history_d.exists():
                  history_d.mkdir(parents=True, exist_ok=True)
                register(r.write_history_file, history_f)
                try:
                    r.read_history_file(history_f)
                except IOError:
                    pass
                r.set_history_length(1000)
            _pdbrc_init()
            del _pdbrc_init
          '';
        };
      in
      {
        text = ''
          import os
          with open(os.path.expanduser("${pdbrcpy}")) as _f: _f = _f.read()
          exec(_f)
          del _f
        '';
        target = ".pdbrc";
      };
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.tmux = (import ./tmux.nix) { inherit selenized isDebian isDarwin; };
  programs.fish = (import ./fish.nix) { inherit isDebian pkgs lib osConfig; };

  programs.git = import ./git.nix { inherit xdgConfigHome isDarwin; };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks."*" = {
      identityFile = "~/.ssh/id_rsa";
    };
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

  programs.alacritty = {
    enable = isDarwin;
    settings = {
      font = {
        size = if isDebian then 11 else 12;
        normal = {
          family = "Iosevka Fixed";
        };
      };
      window = {
        option_as_alt = "OnlyRight";
      };
    } // selenized.alacritty;
  };

  programs.i3status = {
    enable = isDebian;
    enableDefault = false;
    inherit (import ./i3status.nix) general modules;
  };

  programs.gpg = {
    enable = true;
  };
  services.ssh-agent.enable = isDebian;
  services.gpg-agent.enable = isDebian;

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
