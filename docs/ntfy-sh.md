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
sudo -u ntfy-sh ntfy token --add expires=90d nagiosadmin \
  > /var/lib/nagios/ntfy-sh-token
```

Use curl variable expansion to send notification:

```bash
echo "hello" | sudo -u nagios curl \
  --variable token@/var/lib/nagios/ntfy-sh-token \
  --expand-header "Authorization: Bearer {{token}}" \
  -d @- \
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
