{ specialArgs, config, pkgs, projectify, ... }:
let
  uid = 501;
  name = specialArgs.name;
in
{
  imports = [
    ../modules/gpg-agent.nix
    ../modules/nix.nix
    ../modules/openssh.nix
    ../modules/aerospace.nix
    ../modules/overlays.nix
  ];
  users.users."${name}" = {
    description = name;
    shell = pkgs.fish;
    home = "/Users/${name}";
    inherit uid;
  };
  system.primaryUser = name;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.skhd
    pkgs.mosh
  ];
  environment.shells = [ pkgs.fish ];
  environment.variables = {
    TERMINFO_DIRS = [
      "${pkgs.ncurses}/share/terminfo"
      "${pkgs.alacritty.terminfo}/share/terminfo"
    ];
  };

  # Rid ourselves of Apple Music automatically launching
  # https://apple.stackexchange.com/questions/372948/how-can-i-prevent-music-app-from-starting-automatically-randomly/373557#373557
  # Does this actually work? Might have to revisit this
  # Other sources say this works:
  # launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
  # But unload is deprecated in newer versions of launchd
  system.activationScripts.disable-rcd = {
    text = ''
      sudo -u ${name} launchctl bootout gui/${builtins.toString uid}/com.apple.rcd || echo "Already booted out"
      sudo -u ${name} launchctl disable gui/${builtins.toString uid}/com.apple.rcd || echo "Already disabled"
    '';
  };

  launchd.labelPrefix = "net.jwpconsulting";

  # services.karabiner-elements.enable = true;
  services.skhd = {
    enable = true;
    # https://github.com/koekeishiya/skhd/issues/1
    skhdConfig =
      let
        cmus-remote = "${pkgs.cmus}/bin/cmus-remote";
      in
      ''
        play : ${cmus-remote} -u
        rewind : ${cmus-remote} -r
        fast : ${cmus-remote} -n
      '';
  };

  # https://github.com/LnL7/nix-darwin/issues/165#issuecomment-1256957157
  # For iterm2 see:
  # https://apple.stackexchange.com/questions/259093/can-touch-id-on-mac-authenticate-sudo-in-terminal/355880#355880
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  system.defaults = {
    NSGlobalDomain = {
      # https://github.com/alacritty/alacritty/issues/7333#issuecomment-1784737226
      AppleFontSmoothing = 0;
      "com.apple.keyboard.fnState" = true;
      NSDocumentSaveNewDocumentsToCloud = false;
    };
    # XXX broken with
    # ~$defaults write com.apple.universalaccess reduceMotion -bool true
    # 2024-01-27 09:27:42.075 defaults[24764:10236019] Could not write domain com.apple.universalaccess; exiting
    # universalaccess = {
    #   reduceMotion = true;
    # };
    dock = {
      # Hot corner actions
      # Mission control
      wvous-bl-corner = 2;
      # Disabled
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      mru-spaces = false;
      autohide = true;
    };
    # Hide desktop, show all extensions
    finder = {
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      FXEnableExtensionChangeWarning = false;
    };
    loginwindow = {
      GuestEnabled = false;
    };
    screensaver.askForPassword = true;
    screensaver.askForPasswordDelay = null;
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 0.5;
    };
  };
  system.startup.chime = false;

  power.sleep.computer = 3;
  power.sleep.display = 3;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
