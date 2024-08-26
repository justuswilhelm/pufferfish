{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ecryptfs
  ];
  security.pam.enableEcryptfs = true;
  boot.kernelModules = [ "ecryptfs" ];
}
