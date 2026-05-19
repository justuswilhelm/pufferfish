# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  bridgeName = "virbr0";
  extIfName = "enp7s0";
in
{
  # virt-manager
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # Try fixing tpm issue
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;

  # Try fixing group issue
  users.users.${specialArgs.name} = {
    extraGroups = [
      "libvirtd"
    ];
  };

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
    pkgs.guestfs-tools
    pkgs.virt-viewer
  ];

  # helium-cuda specific configuration, see Network settings section in
  # docs/helium-cuda.md
  services.httpd = {
    enable = true;
    virtualHosts."helium-cuda"= {
      hostName = "helium.local";
      listen = [ { ip = "*"; port = 8020; } ];
      locations."/" = {
        proxyPass = "http://helium-cuda.local:8020/";
      };
    };
  };
  networking.firewall.interfaces.${extIfName} = {
    allowedTCPPorts  = [ 8020 ];
  };
  networking.firewall.interfaces.${bridgeName} = {
    # Allow DNS, DHCP from guest domains
    allowedUDPPorts  = [ 53 67 ];
  };
}
