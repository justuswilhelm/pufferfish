<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->

# LVM provisioning

Create a new volume, given:

```bash
sudo lvcreate \
    --size $SIZE \
    --name $VOLUME_NAME \
    $VG_NAME \
    $PV_NAME
sudo mkfs.ext4 -L $VOLUME_NAME $VOLUME_PATH
```

To see PVs, run `sudo pvs`. To see VGs, run `sudo vgs`.

For example, let's create a volume for /etc:

```bash
sudo lvcreate \
    --size 1G \
    --name etc \
    helium-nixos-vg \
    /dev/mapper/nvme0n1p3_crypt
# See the available paths by running `ls /dev/mapper`
sudo mkfs.ext4 -L etc /dev/mapper/helium--nixos--vg-etc
```
