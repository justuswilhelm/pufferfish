<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->

# Setting up neomutt

I add neomutt as a nixpkg in my home.nix

```
  home.packages = [
  ...
    # Email
    pkgs.neomutt
  ...
  ];
```

Let's say I have two mailboxes, `~/mail/a` and `~/mail/b`.

I follow the instructions here https://blog.aktsbot.in/setting-up-neomutt-offlineimap-msmtp.html and pay attention to the last section on neomutt.

I create a main config file and one config file for each in `$DOTFILES/neomutt/`

```
mkdir -p $DOTFILES/neomutt/accounts
touch $DOTFILES/neomutt/neomuttrc
touch $DOTFILES/neomutt/accounts/{a,b}
```

and link the whole thing in home manager by adding the right activation scripts under `home.activation`:

```
(linkScript "${dotfiles}/neomutt" "${xdgConfigHome}")
```
