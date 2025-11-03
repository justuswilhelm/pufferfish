#!/usr/bin/env sh
# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Renew the root CA certificates at /var/lib/lithium-ca

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

install /var/lib/lithium-ca/lithium-ca.crt $HOME/.dotfiles/nix/lithium-ca.crt
git add $HOME/.dotfiles/nix/lithium-ca.crt
git commit --message "Nix: Update lithium-ca.crt"

open /var/lib/lithium-ca/lithium-ca.crt
open /var/lib/lithium-ca
