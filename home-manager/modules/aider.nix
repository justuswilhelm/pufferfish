{ lib, pkgs, config, options, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  config = {
    # https://aider.chat/docs/leaderboards/
    model = "openrouter/anthropic/claude-3.7-sonnet";
    auto-commits = false;
    light-mode = true;
    # Yay, we can enable git again
    # https://aider.chat/HISTORY.html#aider-v0760
    # Fixed Git identity retrieval to respect global configuration, by Akira Komamura.
    git = true;
    analytics = false;
  };
in
{
  home.file.".aider.conf.yml".source = yamlFormat.generate ".aider.conf.yml" config;
  programs.git.ignores = [ ".aider*" ];

  home.packages = [
    pkgs.pipx
    (pkgs.writeShellApplication {
      name = "aid";
      runtimeInputs = [
        pkgs.stdenv.cc.cc.lib
        pkgs.glibc
        pkgs.ungoogled-chromium
      ];
      text = ''
        #!/usr/bin/env bash
        export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib64:${pkgs.stdenv.cc.cc.lib}/lib:''${LD_LIBRARY_PATH:-}"
        pipx run aider-chat "$@"
      '';
    })
  ];
}
