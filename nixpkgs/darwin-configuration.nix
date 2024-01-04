{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # Interpreters
    pkgs.asdf-vm
    pkgs.python311
    pkgs.jq
    pkgs.miller

    # Databases
    pkgs.sqlite

    # Build tools
    pkgs.hugo

    # File conversion
    pkgs.pandoc

    # TUIs
    pkgs.htop
    pkgs.fzf
    pkgs.htop
    pkgs.ncdu
    pkgs.ncurses
    pkgs.neovim
    pkgs.nnn

    # Spellchecking
    pkgs.aspell
    pkgs.aspellDicts.en

    # Shell
    pkgs.fish
    pkgs.mosh
    pkgs.tmux
    pkgs.timewarrior

    # Media
    pkgs.cmus
    pkgs.ffmpeg
    pkgs.imagemagick

    # Networking
    pkgs.curl
    pkgs.nmap

    # File transfers, Backups
    pkgs.borgmatic
    pkgs.rsync
    pkgs.unison

    # Version control
    pkgs.git
    pkgs.git-annex

    # Shell tools
    pkgs.autojump
    pkgs.cloc
    pkgs.fdupes
    pkgs.watch

    # Core tools
    pkgs.silver-searcher
    pkgs.fd
    pkgs.gnused
    pkgs.gnutar
    pkgs.coreutils
    pkgs.moreutils
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
        logPath = toString ~/Library/Logs/borgmatic;
        script = pkgs.writeShellApplication {
          name = "borgmatic-timestamp";
          runtimeInputs = with pkgs; [ borgmatic ts ];
          text = ''
# https://apple.stackexchange.com/a/406097
borgmatic create prune \
  --verbosity 1 \
  --log-file-verbosity 1 \
  --log-file "${logPath}/borgmatic.$(date -Iseconds).log" \
  2> >(ts -m '[%Y-%m-%d %H:%M:%S] -' 1>&2) \
  1> >(ts -m '[%Y-%m-%d %H:%M:%S] -')
        '';
        };
      in {
        Program = "${script}/bin/borgmatic-timestamp";
        StandardOutPath = "${logPath}/borgmatic.stderr.log";
        StandardErrorPath = "${logPath}/borgmatic.stdout.log";
        StartCalendarInterval = [
          {
            Minute = 0;
          }
        ];
        TimeOut = 1800;
      };
    };
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
