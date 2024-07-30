Tested with LibreSSL 3.3.6

Sources:

- https://blog.devolutions.net/2020/07/tutorial-how-to-generate-secure-self-signed-server-and-client-certificates-with-openssl/
- https://gist.github.com/KeithYeh/bb07cadd23645a6a62509b1ec8986bbc
- https://dev.to/techschoolguru/how-to-create-sign-ssl-tls-certificates-2aai

Create the certificates needed to serve the Caddy revproxy from
https://lithium.local

Create the root certificate

```bash
sudo openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /etc/caddy/lithium-ca.key
sudo openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium Root" \
  -x509 \
  -sha256 \
  -days 30 \
  -nodes \
  -key /etc/caddy/lithium-ca.key \
  -out /etc/caddy/lithium-ca.crt
```

Create the server certificate key and signing request:

```bash
sudo openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /etc/caddy/lithium-server.key
sudo openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium.local" \
  -sha256 \
  -nodes \
  -key /etc/caddy/lithium-server.key \
  -out /etc/caddy/lithium-server.csr
```

Sign the certificate signing request:

```bash
echo "
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = serverAuth,clientAuth
subjectAltName = DNS:lithium.local
issuerAltName = issuer:copy
" | sudo tee /etc/caddy/lithium-server.ext
sudo openssl x509 \
  -req \
  -sha256 \
  -in /etc/caddy/lithium-server.csr \
  -CA /etc/caddy/lithium-ca.crt \
  -CAkey /etc/caddy/lithium-ca.key \
  -CAcreateserial \
  -extfile /etc/caddy/lithium-server.ext \
  -out /etc/caddy/lithium-server.crt
```

Mark keys as owner read only, mark certificates as world read only

```bash
sudo chmod 400 /etc/caddy/lithium-*.key
sudo chmod 444 /etc/caddy/lithium-*.crt
```

Copy a user readable CA crt to the Downloads folder:

```bash
sudo cp /etc/caddy/lithium-ca.crt $HOME/Downloads
sudo chown $USER $HOME/Downloads/lithium-ca.crt
```
