{ lib, options, config, pkgs, specialArgs, ... }:
let
  isDebian = specialArgs.system == "debian";
  isDarwin = specialArgs.system == "darwin";
  username = "justusperlwitz";
  homeDirectory = "${specialArgs.homeBaseDirectory}/${username}";
  dotfiles = "${homeDirectory}/.dotfiles";
  xdgConfigHome = "${homeDirectory}/.config";
  xdgDataHome = "${homeDirectory}/.local/share";
  applicationSupport = "${homeDirectory}/Library/Application Support";
  linkScript = from: to:
    ''$DRY_RUN_CMD ln --force --symbolic $VERBOSE_ARG "${from}" "${to}"'';
in {
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = let
    debianOnly = lib.lists.optionals isDebian [
      pkgs.foot
      # TODO
      # pkgs.sway
      # pkgs.i3status
    ];
    darwinOnly = lib.lists.optionals isDarwin [
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

    # File transfers, Backups
    pkgs.rsync
    pkgs.unison

    # Spellchecking
    pkgs.aspell
    pkgs.aspellDicts.en

    # Interpreters
    pkgs.asdf-vm
    pkgs.python311
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

    # Shell
    pkgs.fish
    pkgs.tmux

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
    pkgs.autojump
    pkgs.cloc
    pkgs.fdupes
    pkgs.timewarrior
    pkgs.tree
    pkgs.watch

    # Core tools
    pkgs.silver-searcher
    pkgs.fd
    pkgs.gnused
    pkgs.gnutar
    pkgs.coreutils
    pkgs.moreutils
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
    ];
    shared = [
      (linkScript "${dotfiles}/nvim" "${xdgConfigHome}")
      (linkScript "${dotfiles}/git" "${xdgConfigHome}")
      (linkScript "${dotfiles}/pomoblorbo" "${xdgConfigHome}")
      (linkScript "${dotfiles}/nixpkgs" "${xdgConfigHome}")
      (linkScript "${dotfiles}/nix" "${xdgConfigHome}")
      (linkScript "${dotfiles}/fonts" "${xdgDataHome}")
      (linkScript "${dotfiles}/tmux" "${xdgConfigHome}")
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

  # Workaround for LANG issue
  # https://github.com/nix-community/home-manager/issues/354#issuecomment-475803163
  xdg.configFile.fishSession = {
    enable = isDebian;
    target = "${xdgConfigHome}/fish/conf.d/nix-session.fish";
    text = "set -x LOCALE_ARCHIVE ${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
