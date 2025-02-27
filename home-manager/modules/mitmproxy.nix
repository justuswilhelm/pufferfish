# Infosec related packages and config
{ pkgs, ... }:
{
  home.packages = [ pkgs.mitmproxy ];
  home.file.".mitmproxy/config.yaml".source = ../../mitmproxy/config.yaml;
}
