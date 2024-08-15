{ lib, pkgs, specialArgs, config, osConfig, ... }:
let
  applicationSupport = "${specialArgs.homeDirectory}/Library/Application Support";
in
{
  imports = [
    ./home.nix
    ./aerospace.nix
    ./alacritty.nix
    ./timewarrior.nix
    ./pomoglorbo.nix
    ./infosec.nix
  ];
  programs.fish.loginShellInit =
    let
      # Courtesy of
      # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
      # This naive quoting is good enough in this case. There shouldn't be any
      # double quotes in the input string, and it needs to be double quoted in case
      # it contains a space (which is unlikely!)
      dquote = str: "\"" + str + "\"";

      makeBinPathList = map (path: path + "/bin");
      path = lib.concatMapStringsSep " " dquote (makeBinPathList osConfig.environment.profiles);
    in
    ''
      fish_add_path --move --path ${path}
      set fish_user_paths $fish_user_paths
    '';
  programs.git.ignores = [ ".DS_Store" ];

  home.file.xbar = {
    source = ../../xbar;
    target = "${applicationSupport}/xbar";
    recursive = true;
  };
  xdg.cacheHome = "${specialArgs.homeDirectory}/Library/Caches";

  xdg.configFile.karabiner = {
    source = ../../karabiner/karabiner.json;
    target = "karabiner/karabiner.json";
  };
}
