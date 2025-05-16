{ lib, pkgs, config, ... }:
let
  cfg = config.programs.tmux;
  strip-trailing-nl = pkgs.writeShellApplication {
    name = "strip-trailing-nl";
    runtimeInputs = [ pkgs.gnused ];
    text = ''
      sed -Ez '$ s/\n+$//'
    '';
  };
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
  config = {
    home.sessionVariables = {
      TMUXP_CONFIGDIR = "${config.xdg.configHome}/tmuxp";
    };
    programs.tmux = {
      enable = true;
      extraConfig = ''
        ${builtins.readFile ../../tmux/tmux.conf}
        ${builtins.readFile ../../tmux/vim-tmux-navigator.conf}
        # Copy & paste
        bind-key ']' run "${cfg.pasteCommand} | ${strip-trailing-nl}/bin/strip-trailing-nl | tmux load-buffer - " \; paste-buffer -p -r
        bind-key -T copy-mode-vi 'Enter' send-keys -X copy-pipe-and-cancel '${cfg.copyCommand}'
      '';
      # Set longer scrollback buffer
      historyLimit = 500000;
      # Escape time, for vi
      escapeTime = 10;
      # Mouse input
      mouse = true;
      clock24 = true;
      # vi navigation in tmux screens
      keyMode = "vi";
      # Best compability for true color
      terminal = "screen-256color";
      sensibleOnTop = false;
      shell = "${config.programs.fish.package}/bin/fish";
      tmuxp.enable = true;
    };
  };
}
