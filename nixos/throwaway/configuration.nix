{ config, lib, pkgs, specialArgs, ... }:
{
  imports =
    [
      ../modules/sway.nix
      ../modules/networkd.nix
      ../modules/network-debug.nix
      ../modules/nix.nix
      ../modules/compat.nix
      ../modules/openssh.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking.nix
      ./nordic.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "US/Arizona";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${specialArgs.name}" = {
    isNormalUser = true;
    extraGroups = [
      # Enable ‘sudo’ for the user.
      "wheel"
      # For light command
      "video"
      "dialout"
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = [
    pkgs.rsync
  ];

  programs.fish.enable = true;
  programs.tmux.enable = true;
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.light.enable = true;

  services.openssh = {
    ports = [ 2222 ];
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = lib.mkForce "prohibit-password";
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-ethernet" = {
        networkConfig = {
          DHCP = "yes";
          MulticastDNS = "yes";
          LinkLocalAddressing = "no";
        };
        address = [ "10.0.0.2/24" ];
        routes = [
          {
            Gateway = "10.0.0.1";
          }
        ];
      };
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYV4dnCrWcJambeu0a6OG1mQFdkKaGzmWVzbkqyV/h31rM9tBLbjUTOB/4h/LFiiKo7MLC7L8zUbhtcloGWnyUWXFZOiD1CL4RVB3UH3td6VYBvTvWbob+mYG2YCnaj2wRWYS//qA+GJXWqcmr6HiNGTpQGzbj+zRl1QKJsltF4+MUedjQadgRsF4HEr71QyQLM6/lZOlPb13HuQKtI7WOhL/YHpEz/E9dYHdAuwTzhCJ1+g34IMXD4+QizVEz3eNd2yW6t9IdQl+9QzhkJgvUP1o9NgKeJ4u9YRCvK4DbgyYE5e5/0qO8YCG5ODjc5Lj33/sN+F4tmOIj6x7PNMUAxy4NPyvXwO2weRLXWgns8+zCd3/xnL6fv0ORONOc48cf1M2wpxeZ0x8q+oNdPd7T5Esj8Peo+EXZ0TZp95NoOKwn6+mssPXjtB9aNh6VHfUDirkwJadBq30b5rn5JsLuYSiCVwk1iO5DioQJFdpJW1jaahBTo9uLv3ZyteFEDE8vNZVRWcNX61jp0aP9cXklrXGdfJRj4YEISWlPZqCfP1OBiT9HrxEqk+3pMO7elmRQaUWNPKNsLKQOUKIpRNH12DlA0676ToYVCAHIPCPvYC8DZ4XLmk33/jQ3mmj6tLTeRE+DySbfSNscoyqZ2VWbCt7GPA34Prbr1BjdWi2Cbw== cardno:20_137_860"
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
