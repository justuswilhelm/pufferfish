{ config, ... }:
{
  programs.poetry = {
    enable = true;
    settings = {
      cache-dir = "${config.xdg.cacheHome}/pypoetry";
    };
  };
}
