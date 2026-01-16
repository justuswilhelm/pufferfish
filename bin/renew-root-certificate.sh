#!/usr/bin/env sh
# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Renew the root CA certificates at /var/lib/lithium-ca
set -e

# Want 600
umask 077
sudo -u lithium-ca openssl ecparam \
  -name prime256v1 \
  -genkey \
  -noout \
  -out /var/lib/lithium-ca/secrets/lithium-ca.key

# https://openssl-ca.readthedocs.io/en/latest/create-the-root-pair.html
echo '\
[ req ]
# Options for the `req` tool (`man req`).
default_bits       = 2048
distinguished_name = req_distinguished_name
string_mask        = utf8only

# SHA-1 is deprecated, so use SHA-2 instead.
default_md         = sha256

# Extension to add when the -x509 option is used.
x509_extensions    = v3_ca

[ req_distinguished_name ]
# See <https://en.wikipedia.org/wiki/Certificate_signing_request>.
commonName                      = Common Name
countryName                     = Country Name (2 letter code)
stateOrProvinceName             = State or Province Name
localityName                    = Locality Name
0.organizationName              = Organization Name
organizationalUnitName          = Organizational Unit Name

[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints       = critical, CA:true
keyUsage               = critical, digitalSignature, cRLSign, keyCertSign

[ server_cert ]
# Extensions for server certificates (`man x509v3_config`).
basicConstraints       = CA:FALSE
nsCertType             = server
nsComment              = "OpenSSL Generated Server Certificate"
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer:always
keyUsage               = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth
' | sudo -u lithium-ca tee /var/lib/lithium-ca/openssl.cnf

# Want 644
umask 033
sudo -u lithium-ca openssl req -new \
  -config /var/lib/lithium-ca/openssl.cnf \
  -subj "/C=JP/ST=Tokyo/L=Setagaya City/O=JWP Consulting/OU=Com/CN=lithium root" \
  -x509 \
  -sha256 \
  -days 90 \
  -nodes \
  -key /var/lib/lithium-ca/secrets/lithium-ca.key \
  -out /var/lib/lithium-ca/lithium-ca.crt

install /var/lib/lithium-ca/lithium-ca.crt $HOME/.dotfiles/nix/lithium-ca.crt
git add $HOME/.dotfiles/nix/lithium-ca.crt
git commit --message "Nix: Update lithium-ca.crt"

open /var/lib/lithium-ca/lithium-ca.crt
open /var/lib/lithium-ca
