{ pkgs, ... }: {
  home.packages = [
    pkgs.can-utils
    pkgs.usbutils
    pkgs.cannelloni
  ];
}
