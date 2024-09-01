# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.luks.devices.nvme0n1p4_crypt.device = "/dev/disk/by-uuid/04d9dabf-c8b0-4589-879b-fdfd1e212a75";
  boot.initrd.luks.devices.nvme0n1p3_crypt.device = "/dev/disk/by-uuid/cb8faf69-d547-4511-9916-fff36f9eb475";
  boot.kernelModules = [ "dm-raid" "dm-mirror" "dm-snapshot" ];

  fileSystems."/" =
    {
      device = "/dev/mapper/helium--nixos--vg-nixos--root";
      fsType = "ext4";
    };

  # From Debian /etc/fstab
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/aff0df62-b55a-4410-b7ef-8f933f795f42";
      fsType = "ext2";
    };
  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/C5DD-F6E4";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  fileSystems."/home" =
    {
      device = "/dev/mapper/helium--post--boot--vg-home";
      fsType = "ext4";
    };
  fileSystems."/srv/borgbackup" =
    {
      device = "/dev/mapper/helium--post--boot--vg-borgbackup";
      fsType = "ext4";
    };
  swapDevices = [
    {
      device = "/dev/mapper/helium--nixos--vg-swap";
    }
  ];

  # XXX sda1_crypt and sdb1_crypt keyfiles / uuids have been swapped
  # accidentally during creation
  # XXX order of nvme's is wrong too
  environment.etc.crypttab.text = ''
    nvme0n1p3_crypt UUID=cb8faf69-d547-4511-9916-fff36f9eb475 - luks,discard
    nvme1n1p1_crypt UUID=d9f7c8d9-f07a-415f-a657-e0270794fab2 /etc/keyfiles/nvme1 luks,discard
    nvme2n1p1_crypt UUID=5dbe9083-6787-4e7c-b880-feee7097ad36 /etc/keyfiles/nvme2 luks,discard
    nvme3n1p1_crypt UUID=ac36df35-0c8f-4310-b724-e420c3672d5b /etc/keyfiles/nvme3 luks,discard
    nvme4n1p1_crypt UUID=82ca86e4-3338-483a-a56d-12d0b031ce9d /etc/keyfiles/nvme4 luks,discard
    sda1_crypt UUID=14d440d6-9704-404c-8436-10d276115fe5 /etc/keyfiles/sda luks,discard
    sdb1_crypt UUID=b58e96b5-dbb2-4560-897f-d47310c454af /etc/keyfiles/sdb luks,discard
    sdc1_crypt UUID=9647dca1-5039-4127-9fc5-d6fca07dd228 /etc/keyfiles/sdc luks,discard
  '';

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
