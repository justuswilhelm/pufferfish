{ lib, pkgs, config, options, specialArgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./tmux.nix
    ./cmus.nix
    ./nvim.nix
    ./neomutt.nix
    ./packages.nix
    ./selenized.nix
    ./gpg.nix
    ./fish.nix
    ./asdf.nix
    ./passwordstore.nix
  ];

  home.username = "justusperlwitz";
  home.homeDirectory = specialArgs.homeDirectory;


  home.stateVersion = "24.05";

  home.sessionPath = [
    "${config.home.sessionVariables.DOTFILES}/bin"
  ];

  home.sessionVariables = {
    DOTFILES = "${config.home.homeDirectory}/.dotfiles";
    XDG_CONFIG_HOME = config.xdg.configHome;
    XDG_DATA_HOME = config.xdg.dataHome;
    XDG_STATE_HOME = config.xdg.stateHome;
    XDG_CACHE_HOME = config.xdg.cacheHome;
    NNN_OPENER = "open";
    # XXX Still needed?
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  xdg.dataFile = {
    iosevka = {
      source = ../../fonts/iosevka-fixed-regular.ttf;
      target = "fonts/iosevka-fixed-regular.ttf";
    };
  };

  home.file = {
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

  programs.poetry = {
    enable = true;
    settings = {
      cache-dir = "${config.xdg.cacheHome}/pypoetry";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraOptionOverrides = {
      IdentitiesOnly = "yes";
      IdentityFile = "/dev/null";
    };
  };
}
