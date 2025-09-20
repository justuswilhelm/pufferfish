<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->

# How to troubleshoot some problems

## Less complains when running with tmux (2023-09-13)

This is an issue I had when running less on macOS Venture 13.4

```
less
WARNING: terminal is not fully functional
```

MacPorts installs its own ncurses/tmux/etc. Tmux is set to
give us the following $TERM:

```
set -g default-terminal "tmux-256color"
```

Less and some other core utils are not given by MacPorts but by Apple (not part
of GNU but BSD instead). These Apple provided tools are compiled with a different
version of ncurses, presumably. Anyway, it seems that the old ncurses really
struggles to find the tmux provided terminfo file inside ~/.terminfo/

Simply providing a terminfo folder like so didn't work:

```
env TERMINFO=~/.terminfo less
```

We get the exact same issue. Finally I ran the following and it seems to work
now:

```
/usr/bin/tic tmux-256color
infocmp tmux-256color > tmux-256color
```

Tic is something with ncurses? It's something I picked up on
[StackOverflow](https://unix.stackexchange.com/questions/410335/why-isnt-screen-on-macos-picking-up-my-terminfo)
and in my case I didn't need to go to another machine to pick up the terminfo.
Ncurses just struggles finding it. Running less works now.
