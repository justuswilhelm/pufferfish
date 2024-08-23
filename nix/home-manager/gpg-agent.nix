{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSshSupport = true;
  };

  programs.ssh = {
    matchBlocks."*" = {
      identityFile = "~/.ssh/id_rsa_yubikey.pub";
    };
  };
}
