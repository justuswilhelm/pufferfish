# Install radicale on nix-darwin

Create runtime dirs

```bash
sudo mkdir -p -m 700 /var/local/radicale /var/local/log/radicale
sudo chown -R radicale:radicale /var/local/radicale /var/local/log/radicale
sudo -u radicale mkdir /var/local/radicale/collections
```

Create user account

```bash
sudo -u radicale htpasswd /var/local/radicale/users $USER
```
