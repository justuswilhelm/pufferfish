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
    model = "openrouter/anthropic/claude-sonnet-4";
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
  isLinux = lib.strings.hasSuffix "-linux" specialArgs.system;
in
{
  home.file.".aider.conf.yml".source = yamlFormat.generate ".aider.conf.yml" config;
  programs.git.ignores = [ ".aider*" ];

  home.packages = [
    (pkgs.llm.withPlugins {llm-openrouter=true;} )

    pkgs.goose-cli

    pkgs.aider-chat
  ];
}
