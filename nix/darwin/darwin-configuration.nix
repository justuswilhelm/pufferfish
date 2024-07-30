let
  name = "justusperlwitz";
  uid = 501;
  home = "/Users/${name}";
  library = "${home}/Library";
in
{ config, pkgs, ... }:

{
  imports = [
    ./borgmatic.nix
    ./offlineimap.nix
    ./anki.nix
  ];
  users.users."${name}" = {
    description = "Justus Perlwitz";
    shell = pkgs.fish;
    inherit uid home name;
  };

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
    pkgs.cmus
    pkgs.ffmpeg

    # Nix caching
    pkgs.attic-client
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
    caddyfile = {
      source = ./Caddyfile;
      target = "caddy/Caddyfile";
    };
    atticd = {
      source = ./atticd.toml;
      target = "attic/atticd.toml";
    };
  };

  # Rid ourselves of Apple Music automatically launching
  # https://apple.stackexchange.com/questions/372948/how-can-i-prevent-music-app-from-starting-automatically-randomly/373557#373557
  # Does this actually work? Might have to revisit this
  # Other sources say this works:
  # launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
  # But unload is deprecated in newer versions of launchd
  system.activationScripts.disableRcd.text = ''
    sudo -u ${name} launchctl bootout gui/${uid}/com.apple.rcd
    sudo -u ${name} launchctl disable gui/${uid}/com.apple.rcd
  '';

  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/.config/nix/darwin/darwin-configuration.nix";

  launchd.labelPrefix = "net.jwpconsulting";

  launchd.daemons.attic = {
    serviceConfig =
      let
        logPath = "/var/log/atticd";
        script = pkgs.writeShellApplication {
          name = "run-atticd";
          runtimeInputs = with pkgs; [ attic-server ];
          text = ''
            ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="$(cat /etc/attic/secret.base64)"
            export ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64
            exec atticd --config /etc/attic/atticd.toml
          '';
        };
      in
      {
        KeepAlive = true;
        Program = "${script}/bin/run-atticd";
        StandardOutPath = "${logPath}/attic.stdout.log";
        StandardErrorPath = "${logPath}/attic.stderr.log";
      };
  };


  launchd.daemons.caddy = {
    serviceConfig =
      let
        logPath = "/var/log/caddy";
        script = pkgs.writeShellApplication {
          name = "run-caddy";
          runtimeInputs = with pkgs; [ caddy ];
          text = ''
            exec caddy run --config /etc/caddy/Caddyfile
          '';
        };
      in
      {
        KeepAlive = true;
        Program = "${script}/bin/run-caddy";
        StandardOutPath = "${logPath}/caddy.stdout.log";
        StandardErrorPath = "${logPath}/caddy.stderr.log";
      };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

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

  nix.nixPath = [
    {
      # TODO insert ${home}
      darwin-config = "$HOME/.config/nix/darwin/darwin-configuration.nix";
    }
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.settings.substituters = [
    "https://lithium.local:10100/lithium-default"
  ];
  nix.settings.trusted-public-keys = [
    "lithium-default:12m8tx3dPRBH0y4Gf6t/4eGh7Y8AJ7r2TT0Ug/w9Wvo="
  ];

  nix.settings.trusted-substituters = [
    "https://lithium.local:10100/lithium-default"
  ];

  # nix.package = pkgs.nix;

  # https://github.com/LnL7/nix-darwin/issues/165#issuecomment-1256957157
  # For iterm2 see:
  # https://apple.stackexchange.com/questions/259093/can-touch-id-on-mac-authenticate-sudo-in-terminal/355880#355880
  security.pam.enableSudoTouchIdAuth = true;

  security.pki.certificateFiles = [
    "/etc/caddy/lithium-ca.crt"
  ];

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
