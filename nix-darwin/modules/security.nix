# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# TODO make this a Nix module
# security.pufferfish_default.enable = true
{ ... }:
{
  # https://github.com/LnL7/nix-darwin/issues/165#issuecomment-1256957157
  # For iterm2 see:
  # https://apple.stackexchange.com/questions/259093/can-touch-id-on-mac-authenticate-sudo-in-terminal/355880#355880
  security.pam.services.sudo_local = {
    reattach = true;
    touchIdAuth = true;
  };

  power.sleep.computer = 3;
  power.sleep.display = 3;
  system.defaults = {
    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = true;
      DisableConsoleAccess = true;
    };
    screensaver.askForPassword = true;
    screensaver.askForPasswordDelay = null;
  };
}
