<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->

# ntfy configuration

Docs: https://docs.ntfy.sh/config/

## How to use ntfy-sh and nagios

Create user for nagios:

```bash
sudo -u ntfy-sh ntfy user add nagiosadmin
sudo -u ntfy-sh ntfy access nagiosadmin 'nagios_*' write-only
```

Store new api key in `/var/lib/nagios/ntfy-sh-token`:

```bash
sudo -u ntfy-sh ntfy token add --expires=90d nagiosadmin &| \
  sed -n -E -e 's/token (.+) created .+/\1/p' |
  sudo -u nagios tee /var/lib/nagios/ntfy-sh-token
```

Use curl variable expansion to send notification:

```bash
echo "hello" | sudo -u nagios curl \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  --variable token@/var/lib/nagios/ntfy-sh-token \
  --expand-header "Authorization: Bearer {{token}}" \
  -d @- -v \
  https://lithium.local:10104/nagios_host
```

Adapt the above command to work inside nagios config

Create listener user:

```bash
sudo -u ntfy-sh ntfy user add lithium
sudo -u ntfy-sh ntfy access 'lithium_*' read-only
```

Log in with browser, subscribe to notifications (make sure to enable Firefox
notifications in macOS settings panel)
