<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->

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
nixos-generate --format iso -o result
```

Verify build:

```
~/.dotfiles!+(1)main$file result/iso/nixos.iso
result/iso/nixos.iso: ISO 9660 CD-ROM filesystem data (DOS/MBR boot sector) 'nixos-24.11-x86_64' (bootable)
```

Copy to USB stick:

```bash
pv result/iso/nixos.iso | sudo tee /dev/sdd > /dev/null
```

Create LUKS secrets for carbon:

```bash
sudo mkdir -p /var/lib/carbon-secrets
sudo chmod 700 /var/lib/carbon-secrets
diceware -n5 -d'-' --no-caps | sudo tee /var/lib/carbon-secrets/luks.password
```

Then boot Carbon with USB stick:

```bash
systemctl start sshd.service
passwd root
# Enter pw used for installation
```

Run this on other machine:

```bash
read target_ip
# Test connectivity
ssh -o PasswordAuthentication=yes root@$target_ip
# Run installation
nixos-anywhere --ssh-option PasswordAuthentication=yes \
  --flake .#carbon \
  --target-host root@$target_ip
```

After nixos-anywhere boots into kernel, run the following, in case the IP
address it not retrieved correctly:

```bash
ip address change dev enps0s25 $ip/24
```

