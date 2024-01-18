let
  username = "justusperlwitz";
in
{ user, config, pkgs, ... }:

{
  users.users."${username}" = {
    name = username;
    description = "Justus Perlwitz";
    home = "/Users/${username}";
    shell = pkgs.fish;
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
  environment.etc = {
    terminfo = {
      source = "${pkgs.ncurses}/share/terminfo";
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  launchd.labelPrefix = "net.jwpconsulting";

  launchd.user.agents = {
    "borgmatic" = {
      serviceConfig = let
        logPath = "/Users/${username}/Library/Logs/borgmatic";
        script = pkgs.writeShellApplication {
          name = "borgmatic-timestamp";
          runtimeInputs = with pkgs; [ borgmatic moreutils ];
          text = ''
          borgmatic create prune \
            --log-file-verbosity 1 \
            --log-file "${logPath}/borgmatic.$(date -Iseconds).log"
          '';
        };
      in {
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
      serviceConfig = let
        logPath = "/Users/${username}/Library/Logs/offlineimap";
        script = pkgs.writeShellApplication {
          name = "offlineimap";
          runtimeInputs = with pkgs; [ offlineimap coreutils ];
          text = ''
          mkdir -p "${logPath}" || exit
          exec offlineimap -l "${logPath}/offlineimap.$(date -Iseconds).log"
          '';
        };
      in {
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
      darwin-config = "$HOME/.config/nixpkgs/darwin-configuration.nix";
    }
    "/nix/var/nix/profiles/per-user/root/channels"
  ];


  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
