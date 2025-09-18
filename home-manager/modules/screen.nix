{ lib, pkgs, config, options, ... }:
{
  home.file.".screenrc".text = ''
    defscrolblack ${toString (10 * 1000 * 1000)}
  '';
}
