# Installing on helium

Everything below is run as root

## Install nixos install tools

```bash
nix-env -f '<nixpkgs>' -iA nixos-install-tools
```

## Volume creation

```bash
vgcreate helium-nixos-vg
cryptsetup luksFormat /dev/nvme0n1p4
cryptsetup open /dev/nvme0n1p4 nvme0n1p4_crypt
vgcreate helium-nixos-vg /dev/mapper/nvme0n1p4_crypt
lvcreate \
    --size 250G \
    --name nixos-root \
    helium-nixos-vg \
    /dev/mapper/nvme0n1p4_crypt
mkfs.ext4 /dev/mapper/helium--nixos--vg-nixos--root
mkdir /mnt/nixos-root
```

Mount all volumes

```bash
sudo mount /dev/mapper/helium--nixos--vg-nixos--root /mnt/nixos-root
mount /dev/disk/by-uuid/aff0df62-b55a-4410-b7ef-8f933f795f42 /mnt/nixos-root/boot
mount /dev/disk/by-uuid/C5DD-F6E4 /mnt/nixos-root/boot/efi
```

Yields the following layout on /dev/nvme0

```
nvme0n1                          259:6    0   1.8T  0 disk
├─nvme0n1p1                      259:8    0   487M  0 part  /boot/efi
├─nvme0n1p2                      259:9    0   488M  0 part  /boot
├─nvme0n1p3                      259:10   0   512G  0 part
│ └─nvme0n1p3_crypt              254:0    0   512G  0 crypt
│   ├─helium--vg-root            254:1    0   210G  0 lvm   /
│   ├─helium--vg-swap            254:2    0    50G  0 lvm   [SWAP]
│   ├─helium--vg-tmp             254:3    0  41.9G  0 lvm
│   └─helium--vg-var             254:4    0    20G  0 lvm   /var
├─nvme0n1p4                      259:11   0 418.7G  0 part
│ └─nvme0n1p4_crypt              254:20   0 418.7G  0 crypt
│   └─helium--nixos--vg-nixos--root
│                                254:21   0   250G  0 lvm   /mnt/nixos-root
├─nvme0n1p5                      259:12   0    16M  0 part
└─nvme0n1p6                      259:13   0 931.3G  0 part
```

## Configuration

The biggest challenge was to preserve Debian and make it bootable from
whatever GRUB menu the NixOS installer would create.

Highlights:

```nix
# configuration.nix
{
  boot.loader.efi.canTouchEfiVariables = true;
  # Accomodate Debian's choice of putting EFI in /boot/efi/EFI
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # from /boot/grub/grub.cfg
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.useOSProber = true;
}
```

```nix
# hardware-configuration.nix
{
  fileSystems."/" =
    { device = "/dev/mapper/helium--nixos--vg-nixos--root";
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
}
```

## Installation

```bash
nixos-install \
  --root /mnt/nixos-root/ \
  --flake /home/justusperlwitz/.dotfiles/nix/generic#helium-nixos
```

## Clean up

```bash
umount /mnt/nixos-root/boot/efi
umount /mnt/nixos-root/boot
umount /mnt/nixos-root
cryptsetup close nvme0n1p4_crypt
```
