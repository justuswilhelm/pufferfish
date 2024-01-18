# Configuring OfflineIMAP

I want to try out OfflineIMAP3, the recent Python 3 based version of OfflineIMAP.
Project links are:

- Repository: https://github.com/OfflineIMAP/offlineimap3
- Documentation: https://www.offlineimap.org/documentation.html
- Wiki: https://github.com/OfflineIMAP/offlineimap/wiki

I decide to install it as a nix package, on my Darwin system first. The package
is `pkgs.offlineimap`, the configuration reference is
https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/mail/offlineimap.nix

It looks like just running `offlineimap` in the console after installing makes
it look for `$HOME/.offlineimaprc`. Referring to https://wiki.archlinux.org/title/OfflineIMAP,
it also looks like it will look in `$XDG_CONFIG_HOME/offlineimap`.

We modify and add this sample configuration:

```
[general]
# List of accounts to be synced, separated by a comma.
accounts = main

[Account main]
# Identifier for the local repository; e.g. the maildir to be synced via IMAP.
localrepository = main-local
# Identifier for the remote repository; i.e. the actual IMAP, usually non-local.
remoterepository = main-remote

[Repository main-local]
# OfflineIMAP supports Maildir, GmailMaildir, and IMAP for local repositories.
type = Maildir
# Where should the mail be placed?
localfolders = ~/mail

[Repository main-remote]
# Remote repos can be IMAP or Gmail, the latter being a preconfigured IMAP.
# SSL and STARTTLS are enabled by default.
type = IMAP
remotehost = host.domain.tld
remoteuser = username
# Necessary for SSL connections, if using offlineimap version > 6.5.4
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
```

Since we use mailbox.org and their IMAP, we configure it something like this:

```
[general]
accounts = private-mailbox

[Account private-mailbox]
localrepository = private-mailbox-local
remoterepository = private-mailbox-remote

[Repository private-mailbox-local]
type = Maildir
localfolders = ~/mail/private-mailbox

[Repository private-mailbox-remote]
type = IMAP
remotehost = imap.mailbox.org
remoteuser = username
remotepassfile = ~/.local/var/offlineimap/private-mailbox
ssl_version = tls1_2
tls_level = tls_secure
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
```
