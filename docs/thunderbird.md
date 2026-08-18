<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->

# Thunderbird config issues

## macOS

Using Thunderbird with nix-darwin and GnuPG is messy.

Thunderbird expects the libgpgme dynamic library to be in the right location.
Otherwise, you will see an error like

> invalid configuration, request to use external GnuPG key, but GPGME isn't working

Or maybe you'll see this error:

> send message error

Or maybe you'll see the following in the error console (press cmd+shift+j
to open the error console):

```
Uncaught (in promise) TypeError: can't access property "exportKeys", GPGMELib is null
    getPublicKeysForEmail chrome://openpgp/content/modules/GPGME.sys.mjs:79
    getEncryptionKeyMeta chrome://openpgp/content/modules/keyRing.sys.mjs:1729
    checkRecipientKeys chrome://messenger/content/messengercompose/MsgComposeCommands.js:3521
    checkEncryptionState chrome://messenger/content/messengercompose/MsgComposeCommands.js:3935
    ComposeFieldsReady chrome://messenger/content/messengercompose/MsgComposeCommands.js:3231
    NotifyComposeFieldsReady chrome://messenger/content/messengercompose/MsgComposeCommands.js:603
    InitEditor chrome://messenger/content/messengercompose/MsgComposeCommands.js:11269
    observe chrome://messenger/content/messengercompose/MsgComposeCommands.js:5314
```

Here's where the `TypeError` happens:

```javascript
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const lazy = {};
ChromeUtils.defineESModuleGetters(lazy, {
  EnigmailConstants: "chrome://openpgp/content/modules/constants.sys.mjs",
  GPGMELibLoader: "chrome://openpgp/content/modules/GPGMELib.sys.mjs",
  ctypes: "resource://gre/modules/ctypes.sys.mjs",
});

var GPGMELib;

export var GPGME = {
// […]
  getPublicKeysForEmail(email) {
    function keyFilterFunction(key) {
      if (
        key.contents.bitfield & GPGMELib.gpgme_key_t_revoked ||
        key.contents.bitfield & GPGMELib.gpgme_key_t_expired ||
        key.contents.bitfield & GPGMELib.gpgme_key_t_disabled ||
        key.contents.bitfield & GPGMELib.gpgme_key_t_invalid ||
        !(key.contents.bitfield & GPGMELib.gpgme_key_t_can_encrypt)
      ) {
        return false;
      }

      let matchesEmail = false;
      let nextUid = key.contents.uids;
      while (nextUid && !nextUid.isNull()) {
        const uidEmail = nextUid.contents.email.readString();
        // Variable email is provided by the outer scope.
        if (uidEmail == email) {
          matchesEmail = true;
          break;
        }
        nextUid = nextUid.contents.next;
      }
      return matchesEmail;
    }
    // ERROR HERE:
    return GPGMELib.exportKeys(email, false, keyFilterFunction);
  },
// […]
};
```

The fix is to copy the GPGME library files to one of the directories listed
in the following `ADDITIONAL_LIB_PATHS` variable:

```typescript
// https://github.com/mozilla/releases-comm-central/blob/1945adea3f98cdbe3e19d438ae30ea11058acfe8/mail/extensions/openpgp/content/modules/GPGMELib.sys.mjs#L16
const ADDITIONAL_LIB_PATHS = [
  "/usr/local/lib",
  "/opt/local/lib",
  "/opt/homebrew/lib",
];
```

You can manually link files from GPGME like this, but it will fail once
Nix collects its garbage:


```bash
ln -s (nix path-info nixpkgs#gpgme)/lib/* /usr/local/lib/
```

I found out that my user can write files in /usr/local/lib without
root privileges. Here's why:


```bash
~/.dotfiles!*+(1)main$l /usr/local/lib/
total 0
drwxr-xr-x 5 debian 160 Mar 24  2025 ./
drwxr-xr-x 6 root   192 Jan  9  2026 ../
lrwxr-xr-x 1 debian  78 Dec  1  2024 libgpgme.11.dylib -> /nix/store/64nca5cvy1ni5f8880bf113y2wpgvgql-gpgme-1.23.2/lib/libgpgme.11.dylib
lrwxr-xr-x 1 debian  75 Dec  1  2024 libgpgme.dylib -> /nix/store/64nca5cvy1ni5f8880bf113y2wpgvgql-gpgme-1.23.2/lib/libgpgme.dylib
lrwxr-xr-x 1 debian  72 Dec  1  2024 libgpgme.la -> /nix/store/64nca5cvy1ni5f8880bf113y2wpgvgql-gpgme-1.23.2/lib/libgpgme.la
```

My user owns it? Strange. I've fixed it with `chown root /usr/local/lib`.

A long-term fix is to make this `ln -s` command a nix-darwin system
pre-activation script:

```nix
  system.activationScripts.preActivation = {
    text = let
      gpgme-lib = "${pkgs.gpgme}/lib";
    in
    ''
      echo "Making GPGME libraries available to Thunderbird"
      for lib in ${gpgme-lib}/*; do
        dest="/usr/local/lib/$(basename "$lib")"
        if test -L "$dest" -a -s "$dest"; then
          continue
        elif test -L "$dest" -a ! -s "$dest"; then
          echo "$dest is an empty symlink. Creating new symlink."
          ln -sfv "$lib" "$dest"
        elif test ! -f "$dest"; then
          echo "$dest doesn't exist. Creating new symlink."
          ln -sv "$lib" "$dest"
        else
          echo "$dest is something else and I don't know how to continue"
          stat "$dest"
          exit 1
        fi
      done
    '';
  };
```
