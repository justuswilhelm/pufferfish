{ pkgs, config, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # Install foot-themes
        include = "${config.programs.foot.package.themes}/share/foot/themes/selenized-light";
        font = "Iosevka Fixed:size=11";
      };
    };
  };
}
