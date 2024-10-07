{ config, lib, pkgs, ... }:
{
  # virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Thanks to:
  # https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
  boot.initrd.availableKernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e2d55709398e62cf53e5c7df3758ae52cc62d63a
    # virqfd not needed anymore:
    # "vfio_virqfd"
  ];
  boot.kernelParams = [
    "intel_iommu=on"
    # lspci - nn | grep -i nvidia
    "vfio-pci.ids=10de:2203,10de:1aef"
  ];
  virtualisation.spiceUSBRedirection.enable = true;
  environment.systemPackages = [
    pkgs.pciutils
  ];
}
