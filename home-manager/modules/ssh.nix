# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }:
{
  home.packages = [
    pkgs.mosh
  ];
  programs.ssh = {
    enable = true;
    matchBlocks."*".addKeysToAgent = "yes";
    # Fix the following warning:
    # > trace: warning: debian profile: `programs.ssh` default values will be removed in the future.
    # > Consider setting `programs.ssh.enableDefaultConfig` to false,
    # > and manually set the default values you want to keep at
    # > `programs.ssh.matchBlocks."*"`.
    enableDefaultConfig = false;
    extraOptionOverrides = {
      ConnectTimeout = "5";
      IdentitiesOnly = "yes";
      # Avoid leaking our current user name
      # User = "root";
      # Avoid being prompted for password. Re-enable if needed for specific
      # hosts
      PasswordAuthentication = "no";
    };
  };
}
