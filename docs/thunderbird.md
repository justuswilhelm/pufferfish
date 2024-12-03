# Thunderbird config issues

## macOS

Using Thunderbird with nix-darwin gpg is messy.

Thunderbird expects the libgpgme dynamic library to be in the right location.
Otherwise, you will see an error like

invalid configuration, request to use external GnuPG key, but GPGME isn't working

Or

send message error

How to fix:

This is where thunderbird can find libgpgme:


```typescript
// https://github.com/mozilla/releases-comm-central/blob/1945adea3f98cdbe3e19d438ae30ea11058acfe8/mail/extensions/openpgp/content/modules/GPGMELib.sys.mjs#L16
const ADDITIONAL_LIB_PATHS = [
  "/usr/local/lib",
  "/opt/local/lib",
  "/opt/homebrew/lib",
];
```

Install libgpg as nix flake. Then, one of these did the trick:

```bash
ln -s \
  (nix path-info nixpkgs#gpgme)/lib/libgpgme.la \
  (nix path-info nixpkgs#gpgme)/lib/libgpgme.dylib \
  (nix path-info nixpkgs#gpgme)/lib/libgpgme.11.dylib \
  /usr/local/lib/
```

Also, why can my user write into /usr/local/lib?
