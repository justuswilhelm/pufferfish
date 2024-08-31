# Sources:
# - https://github.com/grahamc/nixos-cuda-example
# - https://wiki.nixos.org/wiki/Nvidia#Modifying_NixOS_configuration
{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.pciutils
    pkgs.cudaPackages.cudatoolkit
  ];

  services.xserver.videoDrivers = [ "intel" "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Use OSS driver
    # https://github.com/NVIDIA/open-gpu-kernel-modules
    # Appears to be compatible with helium's RTX 3070 Ti
    # open = true;
    nvidiaSettings = true;
  };

  # systemd.services.nvidia-control-devices = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  # };

  nixpkgs.config.allowUnfree = true;
}
