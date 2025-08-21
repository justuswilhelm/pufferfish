{ pkgs, config, ... }:
{
  home.sessionVariables = {
    # Thx to
    # https://github.com/drduh/YubiKey-Guide/issues/152#issuecomment-852176877
    PASSWORD_STORE_GPG_OPTS = "--no-throw-keyids";
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
  };
  home.packages = [
    pkgs.pass
    pkgs.diceware
    pkgs.yubikey-manager
  ];
}
