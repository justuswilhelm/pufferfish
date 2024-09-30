Tested with LibreSSL 3.3.6

Sources:

- https://blog.devolutions.net/2020/07/tutorial-how-to-generate-secure-self-signed-server-and-client-certificates-with-openssl/
- https://gist.github.com/KeithYeh/bb07cadd23645a6a62509b1ec8986bbc
- https://dev.to/techschoolguru/how-to-create-sign-ssl-tls-certificates-2aai

Create the certificates needed to serve the Caddy revproxy from
https://lithium.local

# Root CA certs

Create directory for root cert:

```bash
sudo mkdir -p /etc/lithium-ca
sudo chown lithium-ca:lithium-ca /etc/lithium-ca
sudo -u lithium-ca mkdir -m 700 /etc/lithium-ca/secret
sudo -u lithium-ca mkdir /etc/lithium-ca/signed
```

Create the root key

```bash
sudo -u lithium-ca openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /etc/lithium-ca/secret/lithium-ca.key
sudo -u lithium-ca chmod 400 /etc/lithium-ca/secret/lithium-ca.key
```

Create the root certificate

```bash
sudo -u lithium-ca openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium Root" \
  -x509 \
  -sha256 \
  -days 30 \
  -nodes \
  -key /etc/lithium-ca/secret/lithium-ca.key \
  -out /etc/lithium-ca/lithium-ca.crt
sudo -u lithium-ca chmod 644 /etc/lithium-ca/lithium-ca.crt
```

# Caddy certs

Create caddy's cert dirs:

```bash
sudo mkdir -p /etc/caddy/certs
sudo chown caddy:caddy /etc/caddy/certs
sudo -u caddy mkdir -m 700 /etc/caddy/certs/secret
```

Create the server certificate key:

```bash
sudo -u caddy openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /etc/caddy/certs/secret/lithium-server.key
sudo -u caddy chmod 600 /etc/caddy/certs/secret/lithium-server.key
```

Create the caddy server signing request:

```bash
sudo -u caddy openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium.local" \
  -sha256 \
  -nodes \
  -key /etc/caddy/certs/secret/lithium-server.key \
  -out /etc/caddy/certs/lithium-server.csr
sudo -u caddy chmod 644 /etc/caddy/certs/lithium-server.csr
```

Create the caddy server certificate extension file:

```bash
echo "subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = serverAuth,clientAuth
subjectAltName = DNS:lithium.local
issuerAltName = issuer:copy" | \
sudo -u lithium-ca tee /etc/lithium-ca/signed/lithium-server.ext
sudo -u lithium-ca chmod 644 /etc/lithium-ca/signed/lithium-server.ext
```

# CA signed caddy cert

Sign the certificate signing request:

```bash
sudo -u lithium-ca openssl x509 \
  -req \
  -sha256 \
  -in /etc/caddy/certs/lithium-server.csr \
  -CA /etc/lithium-ca/lithium-ca.crt \
  -CAkey /etc/lithium-ca/secret/lithium-ca.key \
  -CAcreateserial \
  -extfile /etc/lithium-ca/signed/lithium-server.ext \
  -out /etc/lithium-ca/signed/lithium-server.crt
sudo -u caddy cp /etc/lithium-ca/signed/lithium-server.crt /etc/caddy/certs/
sudo chmod 644 /etc/caddy/certs/lithium-server.crt
```

# Importing the cert

Open certificate in local keychain:

```bash
open /etc/lithium-ca/lithium-ca.crt
```

Update `nix/lithium-ca.crt`.

```bash
install /etc/lithium-ca/lithium-ca.crt $HOME/.dotfiles/nix/lithium-ca.crt
```

# Restart caddy

```bash
sudo launchctl kill 15 system/net.jwpconsulting.caddy -k -p
```
