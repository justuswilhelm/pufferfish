# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, ... }:
{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      keep-outputs = true;
      keep-derivations = true;
    };
    gc = {
      automatic = true;
      # Run every 6 hours
      interval = builtins.genList (i: { Hour = i * 6; }) 4;
      options = "--delete-older-than 30d";
    };
    settings = {
      sandbox = true;
      extra-sandbox-paths = [ "/nix/store" ];
    };
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
