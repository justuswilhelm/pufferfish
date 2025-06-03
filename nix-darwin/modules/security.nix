{ ... }:
{
  # https://github.com/LnL7/nix-darwin/issues/165#issuecomment-1256957157
  # For iterm2 see:
  # https://apple.stackexchange.com/questions/259093/can-touch-id-on-mac-authenticate-sudo-in-terminal/355880#355880
  security.pam.services.sudo_local.touchIdAuth = true;

  power.sleep.computer = 3;
  power.sleep.display = 3;
  system.defaults = {
    loginwindow = {
      GuestEnabled = false;
    };
    screensaver.askForPassword = true;
    screensaver.askForPasswordDelay = null;
  };
}
