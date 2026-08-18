# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# TODO make this a Nix module
{ pkgs, ... }:
{
  # https://github.com/drduh/YubiKey-Guide?tab=readme-ov-file#ssh
  launchd.user.agents.gpg-agent = {
    path = [ pkgs.gnupg ];
    command = "gpg-connect-agent";
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
  launchd.user.agents.gpg-agent-symlink = {
    path = [ pkgs.coreutils ];
    command = "ln -sf $HOME/.gnupg/S.gpg-agent.ssh $SSH_AUTH_SOCK";
    serviceConfig = {
      RunAtLoad = true;
    };
  };

  # Make gpgme libraries available to Thunderbird, see
  # docs/thunderbird.md
  system.activationScripts.preActivation = {
    text =
      let
        gpgme-lib = "${pkgs.gpgme}/lib";
      in
      ''
        echo "Making GPGME libraries available to Thunderbird"
        for lib in ${gpgme-lib}/*; do
          dest="/usr/local/lib/$(basename "$lib")"
          if test -L "$dest" -a -s "$dest"; then
            continue
          elif test -L "$dest" -a ! -s "$dest"; then
            echo "$dest is an empty symlink. Creating new symlink."
            ln -sfv "$lib" "$dest"
          elif test ! -f "$dest"; then
            echo "$dest doesn't exist. Creating new symlink."
            ln -sv "$lib" "$dest"
          else
            echo "$dest is something else and I don't know how to continue"
            stat "$dest"
            exit 1
          fi
        done
      '';
  };
}
