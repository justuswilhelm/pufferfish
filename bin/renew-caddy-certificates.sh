#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Renew the certificates for caddy
# See docs/caddy.readme.md

set -e

# Want 600
umask 077
# Create a CSR
sudo -u caddy openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /var/lib/caddy/secrets/lithium-server.key

# Want 644
umask 033
sudo -u caddy openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium.local" \
  -sha256 \
  -days 30 \
  -nodes \
  -key /var/lib/caddy/secrets/lithium-server.key \
  -out /var/lib/caddy/certs/lithium-server.csr

# Sign the CSR
sudo -u lithium-ca openssl x509 \
  -req \
  -sha256 \
  -in /var/lib/caddy/certs/lithium-server.csr \
  -CA /var/lib/lithium-ca/lithium-ca.crt \
  -CAkey /var/lib/lithium-ca/secrets/lithium-ca.key \
  -CAcreateserial \
  -extfile /var/lib/lithium-ca/signed/lithium-server.ext \
  -out /var/lib/lithium-ca/signed/lithium-server.crt

# Move the cert into the new location
sudo install -m 644 -o caddy /var/lib/lithium-ca/signed/lithium-server.crt /var/lib/caddy/certs/

# Restart caddy
echo "Restarting caddy"
sudo launchctl kill 15 system/net.jwpconsulting.caddy -k -p
