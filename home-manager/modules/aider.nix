{ lib, pkgs, specialArgs, config, options, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  config = {
    # https://aider.chat/docs/leaderboards/
    model = "openrouter/openai/gpt-5";
    auto-commits = false;
    light-mode = true;
    # Yay, we can enable git again
    # https://aider.chat/HISTORY.html#aider-v0760
    # Fixed Git identity retrieval to respect global configuration, by Akira Komamura.
    git = true;
    analytics = false;
  };
  isLinux = lib.strings.hasSuffix "-linux" specialArgs.system;
in
{
  home.file.".aider.conf.yml".source = yamlFormat.generate ".aider.conf.yml" config;
  programs.git.ignores = [ ".aider*" ];

  home.packages = [
    pkgs.pipx
    (pkgs.writeShellApplication {
      name = "aid";
      runtimeInputs = lib.optionals isLinux [
        pkgs.stdenv.cc.cc.lib
        pkgs.glibc
        pkgs.ungoogled-chromium
        pkgs.bash
      ];
      text = ''
        ${lib.optionalString isLinux ''export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib64:${pkgs.stdenv.cc.cc.lib}/lib:$${LD_LIBRARY_PATH:-}"''}
        export SHELL=bash
        pipx run aider-chat "$@"
      '';
    })
  ];
}
