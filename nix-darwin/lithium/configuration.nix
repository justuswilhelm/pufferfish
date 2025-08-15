{ specialArgs, config, pkgs, projectify, ... }:
let
  uid = 501;
  name = specialArgs.name;
in
{
  imports = [
    ../modules/aerospace.nix
    ../modules/anki.nix
    ../modules/caddy.nix
    ../modules/disable-rcd.nix
    ../modules/gpg-agent.nix
    ../modules/man.nix
    ../modules/nix.nix
    ../modules/offlineimap.nix
    ../modules/openssh.nix
    ../modules/overlays.nix
    ../modules/projectify.nix
    ../modules/radicale.nix
    ../modules/security.nix
    ../modules/user.nix

    ../modules/default.nix

    # ./attic.nix
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
      # TODO add tmux here
    ];
  };


  launchd.labelPrefix = "net.jwpconsulting";

  services.borgmatic.enable = true;
  services.vdirsyncer.enable = true;
  services.sync-git-annex.enable = true;

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
      ./nagios/hosts.cfg
    ];
  };

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
    shellInit = ''
      if test -d /private/etc/manpaths.d
        set --path --export MANPATH
        set --append MANPATH ""
        for f in /private/etc/manpaths.d/*
          for line in (string split "\n" < $f)
            set --append MANPATH $line
          end
        end
      end
    '';
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
