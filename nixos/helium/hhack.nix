# Hardware hacking stuff
{ pkgs, ... } : {
  environment.systemPackages = [
    pkgs.pulseview
    pkgs.sigrok-cli
    pkgs.urjtag
    pkgs.openocd
    pkgs.libftdi
  ];
  services.udev = {
    enable = true;
    packages = [ pkgs.libsigrok ];
  };
}
