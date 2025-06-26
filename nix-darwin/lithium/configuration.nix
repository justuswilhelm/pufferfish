{ specialArgs, config, pkgs, projectify, ... }:
let
  uid = 501;
  name = specialArgs.name;
in
{
  imports = [
    ../modules/nagios.nix
    ../modules/offlineimap.nix
    ../modules/borgmatic.nix
    ../modules/nix.nix
    ../modules/openssh.nix
    ../modules/radicale.nix
    ../modules/ntfy-sh.nix
    ../modules/vdirsyncer.nix
    ../modules/mdns-fix.nix
    ../modules/overlays.nix
    ../modules/projectify.nix
    ../modules/aerospace.nix
    ../modules/newsyslog.nix
    ../modules/disable-rcd.nix
    ../modules/user.nix
    ../modules/security.nix

    ../caddy.nix
    ../anki.nix
    # ./attic.nix
    ../infosec.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # Hot key mapping
    pkgs.skhd
    # TODO re-check these packages after some time passes
    # Databases
    # Not sure if this needs to be available outside somehow
    pkgs.postgresql_15

    # Shell
    # Not sure if this needs to be available outside somehow
    pkgs.mosh

    # Media
    # Not sure if I need these on Debian or not
    pkgs.ffmpeg

    # For thunderbird
    pkgs.gpgme
  ];
  environment.shells = [ pkgs.fish ];
  environment.variables = {
    TERMINFO_DIRS = [
      "${pkgs.ncurses}/share/terminfo"
      "${pkgs.alacritty.terminfo}/share/terminfo"
    ];
  };


  launchd.labelPrefix = "net.jwpconsulting";

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };

  services.nagios = {
    enable = true;
    enableWebInterface = true;
    objectDefs = [
      # Template things
      ./nagios/commands.cfg
      ./nagios/contacts.cfg
      ./nagios/templates.cfg
      ./nagios/timeperiods.cfg
      # My config
      ./nagios/services.cfg
      ./nagios/hosts.cfg
    ];
  };

  services.ntfy-sh.enable = true;

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
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 0.5;
    };
    CustomUserPreferences = {
      "com.apple.dock" = {
        "expose-group-apps" = true;
      };
    };
  };
  system.startup.chime = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
