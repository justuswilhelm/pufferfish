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
