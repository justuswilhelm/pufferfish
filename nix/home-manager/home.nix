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

  home.packages = import ./packages.nix {
    inherit lib isDebian isDarwin pkgs;
    extraPkgs = {
      inherit (specialArgs) pomoglorbo;
    };
  };

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

  programs.git = import ./git.nix { inherit xdgConfigHome isDarwin; };

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
