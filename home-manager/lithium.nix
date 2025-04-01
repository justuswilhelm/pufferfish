{ lib, pkgs, specialArgs, config, osConfig, ... }:
let
  # TODO use cfg.home.homeDirectory
  applicationSupport = "${config.home.homeDirectory}/Library/Application Support";
in
{
  imports = [
    ./modules/aider.nix
    ./modules/alacritty.nix
    ./modules/cmus.nix
    ./modules/neomutt.nix
    ./modules/infosec.nix
    ./modules/pipx.nix
    ./modules/packages.nix
    ./modules/pomoglorbo.nix
    ./modules/cmus.nix
    ./modules/rust.nix
    ./modules/timewarrior.nix

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
  programs.fish.shellAliases.rebuild = "alacritty msg create-window -e $SHELL -c rebuild-nix-darwin";
  programs.git.ignores = [ ".DS_Store" ];

  home.file."${applicationSupport}/xbar" = {
    source = ../xbar;
    recursive = true;
  };
  xdg.cacheHome = "${config.home.homeDirectory}/Library/Caches";

  xdg.configFile."karabiner/karabiner.json".source = ../karabiner/karabiner.json;
  xdg.configFile."fd/ignore".text =
    # These are all directories that can't be walked through by fd, or cause
    # permission popups
    let
      username = config.home.username;
    in
    ''
      /Users/${username}/Library/Accounts
      /Users/${username}/Library/AppleMediaServices
      /Users/${username}/Library/Application Support/AddressBook
      /Users/${username}/Library/Application Support/CallHistoryDB
      /Users/${username}/Library/Application Support/CallHistoryTransactions
      /Users/${username}/Library/Application Support/CloudDocs
      /Users/${username}/Library/Application Support/DifferentialPrivacy
      /Users/${username}/Library/Application Support/FaceTime
      /Users/${username}/Library/Application Support/FileProvider
      /Users/${username}/Library/Application Support/Knowledge
      /Users/${username}/Library/Application Support/MobileSync
      /Users/${username}/Library/Application Support/com.apple.TCC
      /Users/${username}/Library/Application Support/com.apple.avfoundation
      /Users/${username}/Library/Application Support/com.apple.sharedfilelist
      /Users/${username}/Library/Assistant
      /Users/${username}/Library/Autosave Information
      /Users/${username}/Library/Biome
      /Users/${username}/Library/Caches
      /Users/${username}/Library/Calendars
      /Users/${username}/Library/ContainerManager
      /Users/${username}/Library/Containers
      /Users/${username}/Library/Cookies
      /Users/${username}/Library/CoreFollowUp
      /Users/${username}/Library/Daemon Containers
      /Users/${username}/Library/DoNotDisturb
      /Users/${username}/Library/DuetExpertCenter
      /Users/${username}/Library/Group Containers
      /Users/${username}/Library/HomeKit
      /Users/${username}/Library/IdentityServices
      /Users/${username}/Library/IntelligencePlatform
      /Users/${username}/Library/Mail
      /Users/${username}/Library/Messages
      /Users/${username}/Library/Metadata
      /Users/${username}/Library/PersonalizationPortrait
      /Users/${username}/Library/Reminders
      /Users/${username}/Library/Safari
      /Users/${username}/Library/Sharing
      /Users/${username}/Library/Shortcuts
      /Users/${username}/Library/StatusKit
      /Users/${username}/Library/Suggestions
      /Users/${username}/Library/Trial
      /Users/${username}/Library/Weather
      /Users/${username}/Library/com.apple.aiml.instrumentation
    '';

  programs.ssh = {
    matchBlocks."*.local" = {
      identityFile = "~/.ssh/id_rsa";
    };
    matchBlocks."github.com" = {
      identityFile = "~/.ssh/id_rsa";
    };
  };

  home.stateVersion = "24.05";
}
