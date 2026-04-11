# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, ... }:
{
  nix.nixPath = [ "/nix/var/nix/profiles/per-user/root/channels" ];
  nix.extraOptions = ''
    experimental-features = flakes nix-command
  '';
  nix.settings = {
    sandbox = true;
    extra-sandbox-paths = [ "/nix/store" ];
  };
  nix.optimise.automatic = true;
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
