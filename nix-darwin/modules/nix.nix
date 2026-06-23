# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      # Run every 6 hours
      interval = builtins.genList (i: { Hour = i * 6; }) 4;
      options = "--delete-older-than 30d";
    };
    # TODO investigate if you still need this
    nixPath = [ "/nix/var/nix/profiles/per-user/root/channels" ];
    settings = {
      sandbox = true;
      extra-sandbox-paths = [ "/nix/store" ];
    };
    # TODO remove completely
    # optimise.automatic = false;
  };
  # Don't optimise storage. This creates a /nix/store/.links directory
  # with an enormous amount of files
  environment.systemPackages = [
    pkgs.nix-tree
    # Profile nix-darwin evaluation for the current system:
    # $ nix eval --option eval-profiler flamegraph .#darwinConfigurations.$(hostname).system
    # Results in `nix.profile` file.
    # Create flamegraph for `nix.profile` file with flamegraph:
    # $ flamegraph < nix.profile > nix.svg
    pkgs.flamegraph
  ];
}
