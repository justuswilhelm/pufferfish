---
title: Attic configuration
---
Generate a server secret

```bash
openssl rand 32 | base64 | sudo tee /etc/attic/secret.base64
```

How to generate a new JWT token

```fish
nix shell nixpkgs#attic-server
set -x ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64 (sudo cat /etc/attic/secret.base64)
set token (
  atticadm make-token \
    --config /etc/attic/atticd.toml \
    --sub (hostname) \
    --validity "1 month" \
    --pull (hostname)-"*" \
    --push (hostname)-"*" \
    --delete (hostname)-"*" \
    --create-cache (hostname)-"*" \
    --configure-cache (hostname)-"*" \
    --configure-cache-retention (hostname)-"*" \
    --destroy-cache (hostname)-"*"
)
echo $token
attic login lithium https://lithium.local:10100 $token
# attic login lithium http://localhost:18080 $token
attic cache create lithium-default
attic use lithium-default
```

or

```bash
set cache_name lithium
attic login $cache_name https://lithium.local:10100 (
  sudo -u attic \
    ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64=(
      sudo -u attic cat /etc/attic/secret.base64
    ) \
    atticadm \
    make-token \
    --config /etc/attic/atticd.toml \
    --sub $cache_name \
    --validity "3 month" \
    --pull $cache_name-"*" \
    --push $cache_name-"*" \
    --delete $cache_name-"*" \
    --create-cache $cache_name-"*" \
    --configure-cache $cache_name-"*" \
    --configure-cache-retention $cache_name-"*" \
    --destroy-cache $cache_name-"*"
)
sed -n -E -e 's/token = "(.+)"/machine lithium.local\npassword \1/p' \
  ~/.config/attic/config.toml | \
    sudo tee /etc/nix/netrc ~/.config/nix/netrc
```

Test using the following:

```bash
curl --netrc-file ~/.config/nix/netrc -n \
  https://lithium.local:10100/lithium-default/nix-cache-info
```

Or test as root:

```bash
sudo curl --cacert /etc/ssl/certs/ca-certificates.crt \
  --netrc-file /etc/nix/netrc -n \
  https://lithium.local:10100/lithium-default/nix-cache-info
```

This is the ideal response, for both of the above curl invocations:

```
WantMassQuery: 1
StoreDir: /nix/store
Priority: 41
```
