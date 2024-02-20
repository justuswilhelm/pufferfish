{ isDebian, isDarwin, selenized }:
let
  darwinKeys = ''
    # Copy & paste
    bind-key ']' run "pbpaste | tmux load-buffer - " \; paste-buffer -p
    bind-key -T copy-mode-vi 'Enter' send-keys -X copy-pipe-and-cancel 'pbcopy'
  '';
  debianKeys = ''
    # Copy & paste
    bind-key ']' run "wl-paste | tmux load-buffer - " \; paste-buffer -p
    bind-key -T copy-mode-vi 'Enter' send-keys -X copy-pipe-and-cancel 'wl-copy'
  '';
in
{
  enable = true;
  extraConfig = ''
    ${builtins.readFile ../../tmux/tmux.conf}
    ${builtins.readFile ../../tmux/vim-tmux-navigator.conf}
    ${selenized.tmux}
    ${if isDebian then debianKeys else ""}
    ${if isDarwin then debianKeys else ""}
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
