{ lib, pkgs, config, options, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  config = {
    # https://aider.chat/docs/leaderboards/
    model = "anthropic/claude-3-7-sonnet-20250219";
    auto-commits = false;
    light-mode = true;
    # Yay, we can enable git again
    # https://aider.chat/HISTORY.html#aider-v0760
    # Fixed Git identity retrieval to respect global configuration, by Akira Komamura.
    git = true;
  };
in
{
  home.file.".aider.conf.yml".source = yamlFormat.generate ".aider.conf.yml" config;
  programs.git.ignores = [ ".aider*" ];
}
