{ lib, pkgs, config, specialArgs, ... }:
let
  paste = if specialArgs.system == "darwin" then "pbpaste" else "wl-paste";
  copy = if specialArgs.system == "darwin" then "pbcopy"  else "wl-copy";
  selenized = (import ./selenized.nix) { inherit lib; };
in
{
  programs.tmux =
    {
      enable = true;
      extraConfig = ''
        ${builtins.readFile ../../tmux/tmux.conf}
        ${builtins.readFile ../../tmux/vim-tmux-navigator.conf}
        ${selenized.tmux}
        # Copy & paste
        bind-key ']' run "${paste} | tmux load-buffer - " \; paste-buffer -p
        bind-key -T copy-mode-vi 'Enter' send-keys -X copy-pipe-and-cancel '${copy}'
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
}
