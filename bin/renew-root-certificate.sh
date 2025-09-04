#!/usr/bin/env sh
# Want 600
umask 077
sudo -u lithium-ca openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /var/lib/lithium-ca/secrets/lithium-ca.key

# Want 644
umask 033
sudo -u lithium-ca openssl req -new \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium root" \
  -x509 \
  -sha256 \
  -days 90 \
  -nodes \
  -key /var/lib/lithium-ca/secrets/lithium-ca.key \
  -out /var/lib/lithium-ca/lithium-ca.crt

open /var/lib/lithium-ca/lithium-ca.crt
open /var/lib/lithium-ca
