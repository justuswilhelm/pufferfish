---
title: Carbon NixOS install notes
date: 2025-03-22
---

# QEMU VM

```bash
nix run .#nixosConfigurations.carbon.config.system.build.vm
```

# Disko

Refer to:

<https://github.com/nix-community/disko/blob/master/docs/disko-install.md>

Install on USB stick at `/dev/sdb`

```bash
sudo nix run .#disko-install -- --flake $PWD#carbon --disk main /dev/sdb
```

Test the usb stick:

```bash
sudo qemu-kvm -enable-kvm -hda /dev/sdb
```
