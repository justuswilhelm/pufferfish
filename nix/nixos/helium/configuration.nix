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
      ../modules/ime.nix
      ../modules/nix.nix
      ../modules/man.nix
      ../modules/compat.nix
      ../modules/opensnitch.nix
      ../modules/nagios.nix
      ../modules/openssh.nix

      # TODO set up impermanence
      # https://github.com/nix-community/impermanence

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./virtualisation.nix
    ];

  boot.blacklistedKernelModules = [
    "iwlwifi"
    "iwlmvm"
    "nouveau"
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_11;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Accomodate Debian's choice of putting EFI in /boot/efi/EFI
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "helium"; # Define your hostname.
  systemd.network.netdevs.wlo1.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.justusperlwitz = {
    isNormalUser = true;
    extraGroups = [
      # Enable sudo
      "wheel"
      # allow using virtd
      "libvirtd"
      # For serial port
      # https://wiki.nixos.org/wiki/Serial_Console#Unprivileged_access_to_serial_device
      "dialout"
    ];
    home = "/home/justusperlwitz";
    shell = pkgs.fish;
  };

  users.users.lithium-borgbackup = {
    isSystemUser = true;
    group = "lithium-borgbackup";
    shell = pkgs.bash;
    packages = [ pkgs.borgbackup ];
    openssh.authorizedKeys = {
      keys = [
        ''
          ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDiGqRXLFyqRD5yByOnqNID+bkex7O8ZcUJ5SRNOu4W6vQ7aLp+MnhblMBYLRqo2JAV6CQtABC8U2wVM1yvdJzLIXgFLKsK0azCJyPl13QaWltVjV+yTl43qA+ugpyDc68SpkqVjdT9gMPMwYXX2QXN0VPdcbbuN8hhKxp95JRTNETyIWTQuCUTeiGO4hRO2YbBv367v2TmkBRDMXZ2ljk3LsecW1sXrd9p45LUiqLOnw2eKYxQar77X4sVjVB+8nPtlU6CBwa1MrlG/r8QkhvXgbB/Pa9QpsveP9+JCD1LRdwFH3mGgdNIghL3ZtTcTz51cYFnQlZeZRit2YiH78rGMeCev3yOk5Ldjm7wAz/AThteDsbKxJTUEvVsUamXz0NCZIeCH6aTXjPTVGZ5DA857+VoHD1+BYgsbr2jmvWbZPkNJv+PqATNFLX16Z/ih9HvsHrDN9vNiMZECKUVNMxky1JD363lcoHaMqfNtxdbqkEDZe2MlpXi093Xdq0dV+k= borgbackup@lithium
        ''
      ];
    };
  };
  users.groups.lithium-borgbackup = { };
  # TODO add nitrogen-borgbackup

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

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "justusperlwitz" ];
    ensureUsers = [{
      name = "justusperlwitz";
      ensureDBOwnership = true;
      ensureClauses = {
        createdb = true;
      };
    }];
  };

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

