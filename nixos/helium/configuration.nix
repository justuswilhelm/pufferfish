{ config, specialArgs, lib, pkgs, ... }:
{
  imports =
    [
      ../modules/borgmatic.nix
      ../modules/compat.nix
      ../modules/ime.nix
      ../modules/infosec.nix
      ../modules/man.nix
      ../modules/metasploit.nix
      ../modules/mullvad.nix
      ../modules/nagios.nix
      ../modules/network-debug.nix
      ../modules/networkd.nix
      ../modules/nix.nix
      ../modules/opensnitch.nix
      ../modules/openssh.nix
      ../modules/openvpn.nix
      ../modules/podman.nix
      ../modules/sway.nix
      ../modules/yubikey.nix

      # TODO set up impermanence
      # https://github.com/nix-community/impermanence

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./virtualisation.nix
    ];

  boot = {
    kernelModules = [ "dm-raid" "dm-mirror" "dm-snapshot" ];
    blacklistedKernelModules = [ "iwlwifi" "iwlmvm" "nouveau" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # Accomodate Debian's choice of putting EFI in /boot/efi/EFI
      efi.efiSysMountPoint = "/boot/efi";
    };
    initrd.luks.devices = {
      nvme0n1p4_crypt.device = "/dev/disk/by-uuid/04d9dabf-c8b0-4589-879b-fdfd1e212a75";
      nvme0n1p3_crypt.device = "/dev/disk/by-uuid/cb8faf69-d547-4511-9916-fff36f9eb475";
    };
  };

  # XXX sda1_crypt and sdb1_crypt keyfiles / uuids have been swapped
  # accidentally during creation
  # XXX order of nvme's is wrong too
  environment.etc.crypttab.text = ''
    nvme0n1p3_crypt UUID=cb8faf69-d547-4511-9916-fff36f9eb475 - luks,discard
    nvme1n1p1_crypt UUID=d9f7c8d9-f07a-415f-a657-e0270794fab2 /etc/keyfiles/nvme1 luks,discard
    nvme2n1p1_crypt UUID=5dbe9083-6787-4e7c-b880-feee7097ad36 /etc/keyfiles/nvme2 luks,discard
    nvme3n1p1_crypt UUID=ac36df35-0c8f-4310-b724-e420c3672d5b /etc/keyfiles/nvme3 luks,discard
    nvme4n1p1_crypt UUID=82ca86e4-3338-483a-a56d-12d0b031ce9d /etc/keyfiles/nvme4 luks,discard
    sda1_crypt UUID=14d440d6-9704-404c-8436-10d276115fe5 /etc/keyfiles/sda luks,discard
    sdb1_crypt UUID=b58e96b5-dbb2-4560-897f-d47310c454af /etc/keyfiles/sdb luks,discard
    sdc1_crypt UUID=9647dca1-5039-4127-9fc5-d6fca07dd228 /etc/keyfiles/sdc luks,discard
  '';

  systemd.network.netdevs.wlo1.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${specialArgs.name} = {
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
    home = "/home/${specialArgs.name}";
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
    ensureDatabases = [ specialArgs.name ];
    ensureUsers = [{
      name = specialArgs.name;
      ensureDBOwnership = true;
      ensureClauses = {
        createdb = true;
      };
    }];
  };

  security.pki.certificateFiles = [
    ../../nix/lithium-ca.crt
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

