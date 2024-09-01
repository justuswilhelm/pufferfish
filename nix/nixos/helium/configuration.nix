{ config, lib, pkgs, ... }:
{
  imports =
    [
      ../modules/sway.nix
      ../modules/yubikey.nix
      ../modules/networkd.nix
      ../modules/podman.nix
      ../modules/openvpn.nix
      ../modules/borgmatic.nix
      ../modules/infosec.nix

      # TODO set up impermanence
      # https://github.com/nix-community/impermanence

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.blacklistedKernelModules = [
    "iwlwifi"
    "iwlmvm"
  ];
  networking.hosts = {
    "10.0.57.235" = [ "lithium.local" ];
  };

  # TODO
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Accomodate Debian's choice of putting EFI in /boot/efi/EFI
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    enableCryptodisk = true;
  };

  networking.hostName = "helium"; # Define your hostname.
  systemd.network.netdevs.wlo1.enable = false;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.justusperlwitz = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/justusperlwitz";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.mosh.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
  };
  programs.tmux.enable = true;

  environment.systemPackages = [
    pkgs.tree
    pkgs.vim
  ];

  services.openssh.enable = true;

  services.opensnitch.enable = true;

  security.pki.certificateFiles = [
    ../../lithium-ca.crt
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

