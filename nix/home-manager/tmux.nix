{ lib, pkgs, config, ... }:
let
  cfg = config.programs.tmux;
in
{
  options.programs.tmux = with lib; {
    pasteCommand = mkOption {
      type = types.str;
      example = "pbpaste";
      default = "wl-paste";
    };
    copyCommand = mkOption {
      type = types.str;
      example = "pbcopy";
      default = "wl-copy";
    };
  };
  config.programs.tmux =
    {
      enable = true;
      extraConfig = ''
        ${builtins.readFile ../../tmux/tmux.conf}
        ${builtins.readFile ../../tmux/vim-tmux-navigator.conf}
        # Copy & paste
        bind-key ']' run "${cfg.pasteCommand} | tmux load-buffer - " \; paste-buffer -p -r
        bind-key -T copy-mode-vi 'Enter' send-keys -X copy-pipe-and-cancel '${cfg.copyCommand}'
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
