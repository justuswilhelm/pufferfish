Tested with LibreSSL 3.3.6

Sources:

- https://blog.devolutions.net/2020/07/tutorial-how-to-generate-secure-self-signed-server-and-client-certificates-with-openssl/
- https://gist.github.com/KeithYeh/bb07cadd23645a6a62509b1ec8986bbc
- https://dev.to/techschoolguru/how-to-create-sign-ssl-tls-certificates-2aai

Create the certificates needed to serve the Caddy revproxy from
https://lithium.local

Create directory for root cert:

```bash
sudo mkdir -p /etc/lithium-ca
sudo mkdir -m 700 /etc/lithium-ca/secret
```

Create the root certificate

```bash
sudo openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /etc/lithium-ca/secret/lithium-ca.key
sudo chmod 400 /etc/lithium-ca/secret/lithium-ca.key
sudo openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium Root" \
  -x509 \
  -sha256 \
  -days 30 \
  -nodes \
  -key /etc/lithium-ca/secret/lithium-ca.key \
  -out /etc/lithium-ca/lithium-ca.crt
sudo chmod 400 /etc/lithium-ca/secret/lithium-ca.key
sudo chmod =r /etc/lithium-ca/lithium-ca.crt
```

Create the server certificate key:

```bash
sudo mkdir -p /etc/caddy/certs
sudo mkdir -m 700 /etc/caddy/certs/secret
sudo chown caddy:caddy /etc/caddy/certs/secret
sudo openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /etc/caddy/certs/secret/lithium-server.key
sudo chown caddy:caddy /etc/caddy/certs/secret/lithium-server.key
sudo chmod -R 400 /etc/caddy/certs/secret/lithium-server.key
```

Create the caddy server signing request:

```bash
sudo openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium.local" \
  -sha256 \
  -nodes \
  -key /etc/caddy/certs/secret/lithium-server.key \
  -out /etc/caddy/certs/secret/lithium-server.csr
sudo chmod -R 400 /etc/caddy/certs/secret/lithium-server.csr
sudo chown caddy:caddy /etc/caddy/certs/secret/lithium-server.csr
```

Sign the certificate signing request:

```bash
sudo openssl x509 \
  -req \
  -sha256 \
  -in /etc/caddy/certs/secret/lithium-server.csr \
  -CA /etc/lithium-ca/lithium-ca.crt \
  -CAkey /etc/lithium-ca/secret/lithium-ca.key \
  -CAcreateserial \
  -extfile (echo "subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = serverAuth,clientAuth
subjectAltName = DNS:lithium.local
issuerAltName = issuer:copy
" | psub) \
  -out /etc/caddy/certs/lithium-server.crt
sudo chmod 444 /etc/caddy/certs/lithium-server.crt
```

Open certificate in local keychain:

```bash
open /etc/lithium-ca/lithium-ca.crt
```
