{ selenized }: {
  enable = true;
  extraConfig = ''
    ${builtins.readFile ../../tmux/tmux.conf}
    ${builtins.readFile ../../tmux/vim-tmux-navigator.conf}
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
}
