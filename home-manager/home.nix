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
    lib.hm.dag.entryAfter ["writeBoundary"]
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
    pkgs.neovim
    pkgs.tmux
    pkgs.git
    pkgs.fish
  ]
  ++ debianOnly
  ++ darwinOnly;

  home.activation = let
    debianOnly = lib.attrsets.optionalAttrs isDebian {
      poetry = linkScript "${dotfiles}/pypoetry" "${xdgConfigHome}";
      foot = linkScript "${dotfiles}/foot" "${xdgConfigHome}";
      sway = linkScript "${dotfiles}/sway" "${xdgConfigHome}";
      i3status = linkScript "${dotfiles}/i3status" "${xdgConfigHome}";
      home-manager = linkScript "${dotfiles}/home-manager" "${xdgConfigHome}";
      systemd = linkScript "${dotfiles}/systemd" "${xdgConfigHome}";
      x = linkScript "${dotfiles}/x" "${xdgConfigHome}";
      xResources = linkScript "${dotfiles}/x/Xresources" "${xdgConfigHome}/.Xresources";
      xDefaults = linkScript "${dotfiles}/x/Xresources" "${xdgConfigHome}/.Xdefaults";
    };
    darwinOnly = lib.attrsets.optionalAttrs isDarwin {
      poetry = linkScript "${dotfiles}/pypoetry" "${applicationSupport}";
      karabiner = linkScript "${dotfiles}/karabiner" "${xdgConfigHome}";
    };
  in {
      # Darwin + Debian
      nvim = linkScript "${dotfiles}/nvim" "${xdgConfigHome}";
      nvimUpdate = lib.hm.dag.entryAfter ["nvim"] ''
        export PATH=${pkgs.git}/bin:$PATH
        $DRY_RUN_CMD exec ${pkgs.neovim}/bin/nvim \
          --headless \
          +"PlugInstall --sync" +qa
      '';
      tmux = linkScript "${dotfiles}/tmux" "${xdgConfigHome}";
      git = linkScript "${dotfiles}/git" "${xdgConfigHome}";
      pomoglorbo = linkScript "${dotfiles}/pomoblorbo" "${xdgConfigHome}";
      nixpkgs = linkScript "${dotfiles}/nixpkgs" "${xdgConfigHome}";
      nix = linkScript "${dotfiles}/nix" "${xdgConfigHome}";
      fonts = linkScript "${dotfiles}/fonts" "${xdgDataHome}";
    }
    // debianOnly
    // darwinOnly
  ;

  home.stateVersion = "23.11";
  xdg.configFile.fishSession = {
    target = "${xdgConfigHome}/fish/conf.d/nix-session.fish";
    text = "set -x LOCALE_ARCHIVE ${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  programs.home-manager.enable = true;
}
