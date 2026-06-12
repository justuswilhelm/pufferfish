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
  jsonFormat = pkgs.formats.json { };
  self-hosted-model = "google/gemma-4-E4B-it";
  self-hosted-model-url = "http://helium.local:8020/v1";
  # Source for hosted_vllm:
  # https://docs.litellm.ai/docs/providers/vllm
  self-hosted-model-aider = "hosted_vllm/${self-hosted-model}";
  # https://aider.chat/docs/config/aider_conf.html
  config = {
    # https://aider.chat/docs/leaderboards/
    # openai/gpt-5 has high latency. Switched back to claude-sonnet-4
    # openai/qwen3.6-27b-autoround
    # model = "openrouter/anthropic/claude-sonnet-4.6";
    # Local model
    model = self-hosted-model-aider;
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
    # local cuda model, see
    # docs/helium-cuda.md
    openai-api-base = self-hosted-model-url;
    openai-api-key = "none";
  };
  # https://aider.chat/docs/config/adv-model-settings.html#context-window-size-and-token-costs
  # See the following JSON document, too:
  # https://github.com/BerriAI/litellm/blob/main/model_prices_and_context_window.json
  modelMetadata = {
    ${self-hosted-model-aider} = rec {
      # https://github.com/stephan271/Gemma4OnRTX3090#expected-performance
      # > Max Context Limit one slot 262144
      # No idea what "one slot" means, but here we go:
      max_tokens = 32768;
      max_input_tokens = max_tokens;
      max_output_tokens = max_tokens;
      input_cost_per_token = 0;
      output_cost_per_token = 0;
      mode = "chat";
      litellm_provider = "local";
      # supports_tool_choice = true;
      # > Gemma 4 supports function calling with a dedicated tool-call protocol using custom special tokens (<|tool_call>, <tool_call|>, etc.).
      supports_function_calling = true;
      supports_vision = true;
      # supports_reasoning = true;
    };
  };
  # https://aider.chat/docs/config/adv-model-settings.html#default-model-settings
  modelConfig = [
    {
      name = self-hosted-model-aider;
      edit_format = "udiff";
      use_repo_map = true;
      editor_edit_format = "editor-udiff";
    }
    {
      name = "openrouter/anthropic/claude-sonnet-4.6";
      edit_format = "diff";
      use_repo_map = true;
      extra_params = {
        extra_headers = {
          anthropic-beta = "prompt-caching-2024-07-31,pdfs-2024-09-25,output-128k-2025-02-19";
        };
        max_tokens = 640000;
      };
      cache_control = true;
      editor_model_name = "openrouter/anthropic/claude-haiku-4.5";
      editor_edit_format = "editor-diff";
      accepts_settings = [ "thinking_tokens" ];
    }
  ];
  llmExtraModels = [
    {
      model_id = "gemma";
      model_name = self-hosted-model;
      api_base = self-hosted-model-url;
      vision = true;
      supports_schema = true;
    }
  ];
in
{
  # Aider configuration files
  home.file.".aider.conf.yml".source = yamlFormat.generate ".aider.conf.yml" config;
  home.file.".aider.model.metadata.json".source =
    jsonFormat.generate ".aider.model.metadata.json" modelMetadata;
  home.file.".aider.model.settings.yml".source =
    yamlFormat.generate ".aider.model.settings.yml" modelConfig;

  # llm configuration files
  xdg.configFile."io.datasette.llm/extra-openai-models.yaml" = {
    source = yamlFormat.generate "extra-openai-models.yaml" llmExtraModels;
    enable = pkgs.stdenv.hostPlatform != "aarch64-darwin";
  };
  home.file."Library/Application Support/io.datasette.llm/extra-openai-models.yaml" = {
    source = yamlFormat.generate "extra-openai-models.yaml" llmExtraModels;
    enable = pkgs.stdenv.hostPlatform == "aarch64-darwin";
  };

  programs.git.ignores = [ ".aider*" ];

  home.packages = [
    (pkgs.llm.withPlugins { llm-openrouter = true; })

    pkgs.goose-cli

    pkgs.aider-chat
  ];
}
