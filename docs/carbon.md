---
title: Carbon NixOS install notes
date: 2025-03-22
---

# QEMU VM

```bash
nix run .#nixosConfigurations.carbon.config.system.build.vm
```

# Installer ISO

Install on USB stick at `/dev/sdb`

```bash
nixos-generate --flake .#carbon --format iso -o result
```

Verify build:

```
~/.dotfiles!+(1)main$file result/iso/nixos.iso
result/iso/nixos.iso: ISO 9660 CD-ROM filesystem data (DOS/MBR boot sector) 'nixos-24.11-x86_64' (bootable)
```

Copy to USB stick:

```bash
pv result/iso/nixos.iso | sudo tee /dev/sdb > /dev/null
```

Then boot on Carbon and run this on other machine:

```bash
read target_user
read target_ip
nixos-anywhere --ssh-option IdentityFile=$HOME/.ssh/id_rsa_yubikey.pub \
  --flake .#carbon \
  --target-host root@$target_ip
```
nixos-anywhere --ssh-option IdentityFile=$HOME/.ssh/id_rsa_yubikey.pub --flake .#carbon --target-host root@$target_ip
