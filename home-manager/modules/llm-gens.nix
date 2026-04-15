# SPDX-FileCopyrightText: 2014-2026 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  lib,
  pkgs,
  specialArgs,
  config,
  options,
  ...
}:
let
  # Aider config
  yamlFormat = pkgs.formats.yaml { };
  config = {
    # https://aider.chat/docs/leaderboards/
    # openai/gpt-5 has high latency. Switched back to claude-sonnet-4
    model = "openrouter/anthropic/claude-sonnet-4.6";
    auto-commits = false;
    light-mode = true;
    # Yay, we can enable git again
    # https://aider.chat/HISTORY.html#aider-v0760
    # Fixed Git identity retrieval to respect global configuration, by Akira Komamura.
    git = true;
    analytics = false;
    # auto-lint is very fragile
    auto-lint = false;
    # nixpkgs Aider means we can't update it
    check-update = false;
    show-release-notes = false;
  };
  # https://aider.chat/docs/config/adv-model-settings.html
  modelConfig = [{
    name = "openrouter/anthropic/claude-sonnet-4.6";
    edit_format = "udiff";
    use_repo_map = true;
    extra_params = {
      extra_headers = {
        anthropic-beta = "prompt-caching-2024-07-31,pdfs-2024-09-25,output-128k-2025-02-19";
        };
      max_tokens = 1000000;
    };
    cache_control = true;
    editor_model_name = "openrouter/anthropic/claude-haiku-4.5";
    editor_edit_format = "editor-diff";
    accepts_settings = [ "thinking_tokens" ];
  }];
  isLinux = lib.strings.hasSuffix "-linux" specialArgs.system;
in
{
  home.file.".aider.conf.yml".source = yamlFormat.generate ".aider.conf.yml" config;
  home.file.".aider.model.settings.yml".source = yamlFormat.generate ".aider.model.settings.yml" modelConfig;
  programs.git.ignores = [ ".aider*" ];

  home.packages = [
    (pkgs.llm.withPlugins {llm-openrouter=true;} )

    pkgs.goose-cli

    pkgs.aider-chat
  ];
}
