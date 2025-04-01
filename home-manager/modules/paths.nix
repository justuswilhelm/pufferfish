{ lib, pkgs, config, options, specialArgs, ... }:
{
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.sessionVariables.DOTFILES}/bin"
  ];

  # TODO separate module
  home.sessionVariables = {
    DOTFILES = "${config.home.homeDirectory}/.dotfiles";
    XDG_CONFIG_HOME = config.xdg.configHome;
    XDG_DATA_HOME = config.xdg.dataHome;
    XDG_STATE_HOME = config.xdg.stateHome;
    XDG_CACHE_HOME = config.xdg.cacheHome;
    NNN_OPENER = "less";
    # XXX Still needed?
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
}
