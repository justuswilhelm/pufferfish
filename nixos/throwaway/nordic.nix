{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: previous: rec {
      wireshark-cli = previous.wireshark;
      wireshark = previous.symlinkJoin {
        name = "wireshark-with-python";
        paths = [
          previous.wireshark
          (previous.python3.withPackages (pkgs: [ pkgs.pyserial pkgs.psutil ]))
        ];
      };
    })
  ];
  # For NRF
  environment.systemPackages = [
    pkgs.nrfutil
    pkgs.nrfconnect
    pkgs.nrf5-sdk
    pkgs.nrf-udev
    pkgs.nrf-command-line-tools
    pkgs.segger-jlink
  ];

  services.udev.packages = [
    pkgs.nrf-udev
    pkgs.segger-jlink
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.segger-jlink.acceptLicense = true;
  nixpkgs.config.permittedInsecurePackages = [ "segger-jlink-qt4-810" ];
}
