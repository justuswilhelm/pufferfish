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
  selfHostedModel = rec {
    host = "http://helium.local:8020";
    url = "${host}/v1";
    name = "qwen/Qwen3.6-35B-A3B";
    apiKey = "none";
    aiderName = "openai/${name}";
    contextWindow = 262144;
  };
  # Source for hosted_vllm:
  # https://docs.litellm.ai/docs/providers/vllm
  # https://aider.chat/docs/config/aider_conf.html
  aiderConfig = {
    # https://aider.chat/docs/leaderboards/
    # openai/gpt-5 has high latency. Switched back to claude-sonnet-4
    # openai/qwen3.6-27b-autoround
    # model = "openrouter/anthropic/claude-sonnet-4.6";
    # Local model
    model = selfHostedModel.aiderName;
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
    openai-api-base = selfHostedModel.url;
    openai-api-key = selfHostedModel.apiKey;
  };
  # https://aider.chat/docs/config/adv-model-settings.html#context-window-size-and-token-costs
  # See the following JSON document, too:
  # https://github.com/BerriAI/litellm/blob/main/model_prices_and_context_window.json
  aiderModelMetaData = {
    ${selfHostedModel.aiderName} = {
      # https://github.com/stephan271/Gemma4OnRTX3090#expected-performance
      # > Max Context Limit one slot 262144
      # No idea what "one slot" means, but here we go:
      max_tokens = selfHostedModel.contextWindow;
      max_input_tokens = selfHostedModel.contextWindow;
      max_output_tokens = selfHostedModel.contextWindow;
      input_cost_per_token = 0;
      output_cost_per_token = 0;
      mode = "chat";
      litellm_provider = "openai";
      # supports_tool_choice = true;
      # > Gemma 4 supports function calling with a dedicated tool-call protocol using custom special tokens (<|tool_call>, <tool_call|>, etc.).
      supports_function_calling = true;
      supports_vision = true;
      supports_reasoning = true;
    };
  };
  # https://aider.chat/docs/config/adv-model-settings.html#default-model-settings
  aiderModelConfig = [
    {
      name = selfHostedModel.aiderName;
      edit_format = "diff";
      use_repo_map = true;
      editor_edit_format = "editor-diff";
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
  # https://llm.datasette.io/en/stable/other-models.html#openai-compatible-models
  llmExtraModels = [
    {
      # set -Ux LLM_MODEL local
      model_id = "local";
      model_name = selfHostedModel.name;
      api_base = selfHostedModel.url;
      vision = true;
      supports_schema = true;
    }
  ];
  # https://goose-docs.ai/docs/guides/config-files
  gooseConfig = {
    GOOSE_PROVIDER = "ollama";
    GOOSE_MODEL = selfHostedModel.name;
    OLLAMA_HOST = selfHostedModel.host;
    GOOSE_MODE = "approve";
    GOOSE_CLI_THEME = "light";
    SECURITY_PROMPT_ENABLED = true;
    # OPENAI_BASE_PATH = "v1/chat/completions";
    extensions = {
      developer = {
        bundled = true;
        enabled = true;
        name = "developer";
        timeout = 300;
        type = "builtin";
      };
      memory = {
        bundled = true;
        enabled = true;
        name = "memory";
        timeout = 300;
        type = "builtin";
      };
    };
  };
  goosePermission = {
  };
  # https://pi.dev/docs/latest/settings
  piConfig = {
    theme = "light";
    defaultProvider = "local";
    defaultModel = selfHostedModel.name;
  };
  piModels = {
    providers = {
      local = {
        baseUrl = selfHostedModel.url;
        api = "openai-completions";
        apiKey = "none";
        models = [
          {
            id = selfHostedModel.name;
            contextWindow = selfHostedModel.contextWindow;
            maxTokens = 32000;
            input = ["text" "image"];
            reasoning = true;
          }
        ];
      };
    };
  };
in
{
  # Aider configuration files
  # aider prefers .yml and will silently error out
  # Feel the bitrot
  home.file.".aider.conf.yml".source = yamlFormat.generate ".aider.conf.yml" aiderConfig;
  home.file.".aider.model.metadata.json".source =
    jsonFormat.generate ".aider.model.metadata.json" aiderModelMetaData;
  home.file.".aider.model.settings.yml".source =
    yamlFormat.generate ".aider.model.settings.yml" aiderModelConfig;

  # llm configuration files
  xdg.configFile."io.datasette.llm/extra-openai-models.yaml" = {
    source = yamlFormat.generate "extra-openai-models.yaml" llmExtraModels;
    enable = pkgs.stdenv.isLinux;
  };
  home.file."Library/Application Support/io.datasette.llm/extra-openai-models.yaml" = {
    source = yamlFormat.generate "extra-openai-models.yaml" llmExtraModels;
    enable = pkgs.stdenv.isDarwin;

  };

  # Goose
  xdg.configFile."goose/config.yaml".source = yamlFormat.generate "config.yaml" gooseConfig;
  xdg.configFile."goose/permission.yaml".source = yamlFormat.generate "permission.yaml" goosePermission;

  # Pi
  home.file.".pi/agent/settings.json".source = jsonFormat.generate "settings.json" piConfig;
  home.file.".pi/agent/models.json".source = jsonFormat.generate "models.json" piModels;

  programs.git.ignores = [ ".aider*" ];

  home.packages = [
    (pkgs.llm.withPlugins { llm-openrouter = true; })

    pkgs.goose-cli

    pkgs.aider-chat
    pkgs.pi-coding-agent
  ];
}
