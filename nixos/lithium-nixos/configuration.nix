# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, specialArgs, pkgs, ... }:

{
  imports =
    [
      ../modules/compat.nix
      ../modules/infosec.nix
      ../modules/man.nix
      ../modules/networkd.nix
      ../modules/network-debug.nix
      ../modules/nix.nix
      ../modules/openssh.nix
      ../modules/sway.nix
      ../modules/utm.nix
      ../modules/yubikey.nix
      ../modules/wlan.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./wireguard.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://wiki.qemu.org/Documentation/Networking

  time.timeZone = "Asia/Tokyo";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${specialArgs.name}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  environment.shells = [ pkgs.fish ];

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.tmux.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}

