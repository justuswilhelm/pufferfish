{ lib, pkgs, config, options, ... }:
{
  home.file.".aider.conf.yml".text = ''
    haiku: true
    auto-commits: false
    light-mode: true
    git: false
  '';
  programs.git.ignores = [ ".aider*" ];
}
