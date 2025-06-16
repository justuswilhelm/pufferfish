{ lib, pkgs, specialArgs, config, options, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  config = {
    # https://aider.chat/docs/leaderboards/
    model = "openrouter/anthropic/claude-sonnet-4";
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
      runtimeInputs = lib.optional isLinux [
        pkgs.stdenv.cc.cc.lib
        pkgs.glibc
        pkgs.ungoogled-chromium
      ];
      text = ''
        ${lib.strings.optionalString isLinux "export LD_LIBRARY_PATH='${pkgs.stdenv.cc.cc.lib}/lib64:${pkgs.stdenv.cc.cc.lib}/lib:''$${LD_LIBRARY_PATH:-}'"}
        pipx run aider-chat "$@"
      '';
    })
  ];
}
