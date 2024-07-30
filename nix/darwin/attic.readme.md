Generate a server secret

```
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
