---
title: Throwaway NixOS install notes
---

Copied from `docs/carbon.md`. Meant to be installed and then thrown away.
No LUKS.

# Installer ISO

Download minimal NixOS installer, copy to usb stick

Copy to USB stick:

```bash
pv result/iso/nixos.iso | sudo tee /dev/sdd > /dev/null
```

Then boot Throwaway with USB stick:

```bash
sudo systemctl start sshd.service
sudo passwd root
# Enter pw used for installation
```

Run this on other machine:

```bash
read target_ip
# Test connectivity
ssh -o PasswordAuthentication=yes root@$target_ip
# Run installation
nixos-anywhere --ssh-option PasswordAuthentication=yes \
  --flake .#throwaway \
  --target-host root@$target_ip
```

If you are running this on darwin and it fails to build, add the `--build-on remote` flag
after `--target-host root@$target_ip`:

```
* --build-on auto|remote|local
  sets the build on settings to auto, remote or local. Default is auto.
  auto: tries to figure out, if the build is possible on the local host, if not falls back gracefully to remote build
  local: will build on the local host
  remote: will build on the remote host
```

After nixos-anywhere boots into kernel, run the following, in case the IP
address it not retrieved correctly:

```bash
ip address change dev enps0s25 $ip/24
```

# Change configuration

```bash
NIX_SSHOPTS="-i $HOME/.ssh/id_rsa_yubikey.pub -p2222" \
  nixos-rebuild --flake .#throwaway switch \
  --build-host root@$target_ip \
  --target-host root@$target_ip
```

If you are on darwin, add the `--fast` flag.
