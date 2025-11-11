# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, pkgs, specialArgs, ... }:
{
  imports =
    [
      ../modules/sway.nix
      ../modules/networkd.nix
      ../modules/nix.nix
      ../modules/compat.nix
      ../modules/openssh.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

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
    ];
    shell = pkgs.fish;
  };

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

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCXBdOyd39mbxF+KdoKF2DvRVtAydzldUZnRXdpS0fdG33fiicqBYRH5wwRDL9cnWFrST7qlBJJ1H/1x6tk8WMTGK6k1V369ZCmf3VYQ28+GXGh0MUiueRq7wwFCKdnrbiR2BTegFgHpm0w71g4vVLkm12cQfduBAzmBG1gG1RYVk1JsMXzeImzK1A1yP/k6abo5Gu2YR2O1a/2D2RUiGlqBaGXMYiT+FhpsM/KobDGLXkjOaPj1FhbSFjzogKZcyKmtVCcSVSe617nub5DhdSd4ywF+sCszlrfR3Va08OpjKHAFQCkEF9QpZzYULjdURakvl8xH5lZVQqRhzb5s0ndYOxzt+j4rhX8dk+4BuVFOOKBbkdytSi1ni7K8FNtzqS+X12wNuJe9dFI6tPaZ1D18SeQslOoGawMhqMPItHhWPEs3nH34RM8yYQM/fiEPW1E8g4+HVjja4a7OSehOwYKohrDo266x1nTzMQULdcdEKOWK0jM/G+m1tuWPmB/L00= justus@jwpconsulting.net"
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
  system.stateVersion = "24.11"; # Did you read the comment?

}
