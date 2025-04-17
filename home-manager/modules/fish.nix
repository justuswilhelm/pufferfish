{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_config theme choose "Solarized Light"
    '';
    shellAbbrs = {
      # Fish abbreviations
      # ------------------
      # Reload fish session. Useful if config.fish has changed.
      reload = "exec fish";

      # File abbreviations
      # ------------------
      # Ls shortcut with color, humanized, list-based output
      l = "ls -lhaG";

      # Neovim abbreviations
      # --------------------
      # Start neovim
      e = "nvim";
    };
  };

  xdg.configFile = {
    "fish/functions" = {
      source = ../../fish/functions;
      recursive = true;
    };
    "fish/completions" = {
      source = ../../fish/completions;
      recursive = true;
    };
  };
}
