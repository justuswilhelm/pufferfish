let
  username = "justusperlwitz";
  homeDirectory = "/Users/${username}";
  dotfiles = "${homeDirectory}/.dotfiles";
  in
{ pkgs, ... }: {
  home.username = username;
  home.homeDirectory = homeDirectory;

  # TODO
  # - nvim
  # - git
  # - pomoglorbo
  # - cmus or mpd
  # TODO macOS only:
  # - pypoetry (to Library/Application Support)
  # - karabiner
  # TODO Debian only:
  # - pypoetry
  # - foot
  # - sway
  # - i3status
  # - systemd
  # - x
  # - Xresources
  # - Xdefaults
  # - fonts
  xdg.configFile = {
    tmux = {
      source = ../tmux;
      target = "tmux";
    };
  };

  # TODO ensure nvim plugins update
  # TODO ensure fish is default shell

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
