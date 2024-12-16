Tested with LibreSSL 3.3.6

Sources:

- https://blog.devolutions.net/2020/07/tutorial-how-to-generate-secure-self-signed-server-and-client-certificates-with-openssl/
- https://gist.github.com/KeithYeh/bb07cadd23645a6a62509b1ec8986bbc
- https://dev.to/techschoolguru/how-to-create-sign-ssl-tls-certificates-2aai

Create the certificates needed to serve the Caddy revproxy from
https://lithium.local

# Root CA secret

Create directory for root cert:

```bash
sudo mkdir -p /var/lib/lithium-ca
sudo chown lithium-ca:lithium-ca /var/lib/lithium-ca
sudo -u lithium-ca mkdir -m 700 /var/lib/lithium-ca/secrets
sudo -u lithium-ca mkdir /var/lib/lithium-ca/signed
```

Create the root key

```bash
sudo -u lithium-ca openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /var/lib/lithium-ca/secrets/lithium-ca.key
sudo -u lithium-ca chmod 600 /var/lib/lithium-ca/secrets/lithium-ca.key
```

# Root CA cert

Create the root certificate. These steps also apply when renewing the `lithium
Root` certificate.

```bash
sudo -u lithium-ca openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium Root" \
  -x509 \
  -sha256 \
  -days 90 \
  -nodes \
  -key /var/lib/lithium-ca/secrets/lithium-ca.key \
  -out /var/lib/lithium-ca/lithium-ca.crt
sudo -u lithium-ca chmod 644 /var/lib/lithium-ca/lithium-ca.crt
```

# Caddy certs

Create caddy's cert dirs:

```bash
sudo chown caddy:caddy /var/lib/caddy

sudo mkdir -p /var/lib/caddy/certs
sudo chmod 755 /var/lib/caddy/certs

sudo -u caddy mkdir -m 700 /var/lib/caddy/secrets
```

Create the server certificate key:

```bash
sudo -u caddy openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /var/lib/caddy/secrets/lithium-server.key
sudo -u caddy chmod 600 /var/lib/caddy/secrets/lithium-server.key
```

# Caddy's cert signing request

The following step also applies when renewing caddys' cert after expiration.

Create the caddy server signing request:

```bash
sudo -u caddy openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium.local" \
  -sha256 \
  -days 30 \
  -nodes \
  -key /var/lib/caddy/secrets/lithium-server.key \
  -out /var/lib/caddy/certs/lithium-server.csr
sudo -u caddy chmod 644 /var/lib/caddy/certs/lithium-server.csr
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
sudo -u lithium-ca tee /var/lib/lithium-ca/signed/lithium-server.ext
sudo -u lithium-ca chmod 644 /var/lib/lithium-ca/signed/lithium-server.ext
```

# CA signed caddy cert

The following step also applies when renewing the cert.

Sign the certificate signing request:

```bash
sudo -u lithium-ca openssl x509 \
  -req \
  -sha256 \
  -in /var/lib/caddy/certs/lithium-server.csr \
  -CA /var/lib/lithium-ca/lithium-ca.crt \
  -CAkey /var/lib/lithium-ca/secrets/lithium-ca.key \
  -CAcreateserial \
  -extfile /var/lib/lithium-ca/signed/lithium-server.ext \
  -out /var/lib/lithium-ca/signed/lithium-server.crt
sudo -u caddy cp /var/lib/lithium-ca/signed/lithium-server.crt /var/lib/caddy/certs/
sudo chmod 644 /var/lib/caddy/certs/lithium-server.crt
```

# Importing the cert

The following instructions are also valid if the root cert expired.

On Mac: Open `Keychain Access`. Delete certificate called "lithium Root" if exists.

Open certificate in local keychain:

```bash
open /var/lib/lithium-ca/lithium-ca.crt
```

Open certificate in *Default Keychains* > *login*. Under *Trust*, choose "Always Trust" for **Secure Sockets Layer (SSL)**. Close and confirm by entering administration password.

Update `nix/lithium-ca.crt`.

```bash
install /var/lithium-ca/lithium-ca.crt $HOME/.dotfiles/nix/lithium-ca.crt
```

# Restart caddy

These steps are also to be used when caddy's cert expires.

```bash
sudo launchctl kill 15 system/net.jwpconsulting.caddy -k -p
```
