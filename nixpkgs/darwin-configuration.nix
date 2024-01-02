{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # Interpreters
    pkgs.python311

    # Build tools
    pkgs.hugo

    # File conversion
    pkgs.pandoc

    # TUIs
    pkgs.ncurses
    pkgs.neovim

    # Shell
    pkgs.fish
    pkgs.mosh

    # Media
    pkgs.cmus
    # TODO ffmpeg/imagemagick

    # Networking
    pkgs.curl
    pkgs.nmap

    # TODO borgmatic/borg

    # Version control
    pkgs.git
    pkgs.git-annex

    # Shell tools
    pkgs.fdupes
    pkgs.fzf
    pkgs.fd
    pkgs.nnn
    pkgs.watch
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
