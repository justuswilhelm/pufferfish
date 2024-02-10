let
  username = "justusperlwitz";
  uid = 501;
in
{ user, config, pkgs, ... }:

{
  users.users."${username}" = {
    name = username;
    description = "Justus Perlwitz";
    home = "/Users/${username}";
    shell = pkgs.fish;
    inherit uid;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # TODO re-check these packages after some time passes
    # Databases
    # Not sure if this needs to be available outside somehow
    pkgs.postgresql_15

    # Shell
    # Not sure if this needs to be available outside somehow
    pkgs.mosh

    # Media
    # Not sure if I need these on Debian or not
    pkgs.cmus
    pkgs.ffmpeg

    # File transfers, Backups
    # Can this be put in the home config?
    pkgs.borgmatic

    # Mail - runs as a launchagent, so not sure if this makes sense as a home
    # manager package
    pkgs.offlineimap
  ];
  environment.shells = [ pkgs.fish ];
  environment.variables = {
    TERMINFO_DIRS = [
      "${pkgs.ncurses}/share/terminfo"
      "${pkgs.alacritty.terminfo}/share/terminfo"
    ];
  };
  environment.etc = {
    sshd_config = {
      source = ./sshd_config;
      target = "ssh/sshd_config";
    };
  };

  # Rid ourselves of Apple Music automatically launching
  # https://apple.stackexchange.com/questions/372948/how-can-i-prevent-music-app-from-starting-automatically-randomly/373557#373557
  # Does this actually work? Might have to revisit this
  # Other sources say this works:
  # launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
  # But unload is deprecated in newer versions of launchd
  system.activationScripts.disableRcd.text = ''
    sudo -u ${username} launchctl bootout gui/${uid}/com.apple.rcd
    sudo -u ${username} launchctl disable gui/${uid}/com.apple.rcd
  '';

  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/.config/nix/darwin/darwin-configuration.nix";

  launchd.labelPrefix = "net.jwpconsulting";

  launchd.user.agents = {
    "borgmatic" = {
      serviceConfig =
        let
          logPath = "/Users/${username}/Library/Logs/borgmatic";
          script = pkgs.writeShellApplication {
            name = "borgmatic-timestamp";
            runtimeInputs = with pkgs; [ borgmatic moreutils ];
            text = ''
              mkdir -p "${logPath}" || exit
              borgmatic create prune \
                --log-file-verbosity 1 \
                --log-file "${logPath}/borgmatic.$(date -Iseconds).log"
            '';
          };
        in
        {
          Program = "${script}/bin/borgmatic-timestamp";
          StartCalendarInterval = [
            {
              Minute = 0;
            }
          ];
          TimeOut = 1800;
        };
    };
    "offlineimap" = {
      serviceConfig =
        let
          logPath = "/Users/${username}/Library/Logs/offlineimap";
          script = pkgs.writeShellApplication {
            name = "offlineimap";
            runtimeInputs = with pkgs; [ offlineimap coreutils ];
            text = ''
              mkdir -p "${logPath}" || exit
              exec offlineimap -l "${logPath}/offlineimap.$(date -Iseconds).log"
            '';
          };
        in
        {
          Program = "${script}/bin/offlineimap";
          # Every 5 minutes
          StartInterval = 5 * 60;
          # Time out after 3 minutes
          TimeOut = 3 * 60;
        };
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };

  nix.nixPath = [
    {
      darwin-config = "$HOME/.config/nix/darwin/darwin-configuration.nix";
    }
    "/nix/var/nix/profiles/per-user/root/channels"
  ];


  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # https://github.com/LnL7/nix-darwin/issues/165#issuecomment-1256957157
  # For iterm2 see:
  # https://apple.stackexchange.com/questions/259093/can-touch-id-on-mac-authenticate-sudo-in-terminal/355880#355880
  security.pam.enableSudoTouchIdAuth = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
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
    };
    # Hide desktop, show all extensions
    finder = {
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      FXEnableExtensionChangeWarning = false;
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
