# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib, pkgs, specialArgs, config, osConfig, ... }:
let
  applicationSupport = "${config.home.homeDirectory}/Library/Application Support";
in
{
  imports = [
    ./modules/alacritty.nix
    ./modules/cmus.nix
    ./modules/fd.nix
    ./modules/infosec.nix
    ./modules/packages.nix

    ./home.nix
  ];

  programs.cmus = {
    enable = true;
    output_plugin = "coreaudio";
  };

  programs.tmux = {
    pasteCommand = "pbpaste";
    copyCommand = "pbcopy";
  };

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
  programs.fish.shellAliases.rebuild = "sudo darwin-rebuild switch --flake $DOTFILES";
  programs.git.ignores = [ ".DS_Store" ];

  xdg.cacheHome = "${config.home.homeDirectory}/Library/Caches";

  xdg.configFile."karabiner/karabiner.json".source = ../karabiner/karabiner.json;

  # From ./modules/gpg-agent.nix
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
  programs.ssh = {
    matchBlocks."*.local" = {
      identityFile = "~/.ssh/id_rsa_yubikey";
    };
    matchBlocks."github.com" = {
      identityFile = "~/.ssh/id_rsa_yubikey";
    };
  };

  home.file."Library/Fonts/iosevka-fixed-regular.ttf".source = ../fonts/iosevka-fixed-regular.ttf;

  home.stateVersion = "24.05";
}
