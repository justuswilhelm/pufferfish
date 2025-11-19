<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->

# Install radicale on nix-darwin

Create runtime dirs

```bash
sudo mkdir -p -m 700 /var/local/radicale /var/local/log/radicale
sudo chown -R radicale:radicale /var/local/radicale /var/local/log/radicale
sudo -u radicale mkdir /var/local/radicale/collections
```

Create user account

```bash
sudo -u radicale htpasswd -B -c /var/local/radicale/users $USER
```
