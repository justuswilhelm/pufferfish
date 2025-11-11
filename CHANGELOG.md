<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->
# Change Log

Written according to [http://keepachangelog.com](Keep a Changelog).

## [2024-01-27]

### Added

- neomutt config in `neomutt/`
- 24-bit-color test program in `bin/`
- pomoglorbo as a nix flake
- cmus config in `cmus/`

### Changed

- Nix directly manages most of my dotfiles now and they are just symbolic links
  added through home manager and nix-darwin.
- Disable Apple Music auto-launch when pressing media keys
- Relicense as GPL v3 or later
- Unify debian and darwin nix config

### Removed

- bin/abbr_doc script

## [2024-01-16]

I haven't written to this changelog for 9 years, woops! A lot has changed since
I first started maintaining this repository. I have been using these dotfiles
on Debian and macOS, and I am slowly migrating over to using Nix for many of my
configuration needs. I have also switched over from i3 to sway, after being
dissatisfied with Xorg's HiDPI support. My workflow is more keyboard driven
than ever, and I prefer staying in the terminal for more tasks than before.

Here is a recap of the things that have been added, changed or removed. Keep in
mind that this shows the current state, but in the meantime many more things
have been added and removed, but they just didn't make it to be here with us
today.

### Added

- irssi config in `irssi/`
- sway config in `sway/`
- tmux config in `tmux/`
- karabiner config in `karabiner/`
- foot config in `foot/`
- gdb config in `gdb/`
- Iosevka font in `fonts/`
- home manager config in `home-manager`
- nix darwin config in `nixpkgs`
- nix config in `nix`
- i3status config in `i3status/`
- Sway config in `sway/`
- Selenized color schemes in `macos-terminal-selenized/` and `selenized/`
- Plenty of fish functions and abbreviations
- Nvim uses many more plugins (LSP, Treesitter, orgmode, ...)
- Nvim snippets in `nvim/snippets/`
- systemd user units in `systemd/`

### Removed

- A lot, but it's still the same maintainer. ʕ ▀ ڡ ▀ ʔ

### Changed

- The world is a different place now than back then, but all in all we are
  still doing fine. :)

## [4.1.0] - 2015-12-01

### Added

- RVM script to fish shell
- Local bin folder
- Bootstrap script handles pip3 config

### Fixed

- Ignore fish read history in git
- Broken backticks in `gp`

### Modified

- Use expect to install nvim plugins
- Use Skim app in `~/.latexmkrc`

## [4.0.0] - 2015-11-09

### Added

- NeoVim Plugins: EasyMotion, Numbertoggle, Elixir Syntax, Indentline
- New helper methods for fish.

## [3.0.0] - 2015-07-29

### Added

- Rust syntax for neovim
- Fish right prompt looks cooler
- Solarized colorscheme
- Vim-Surround
- Netrw configuration
- Autojump config for fish

### Removed

- NerdTree

### Fixed

- gi was badly written

### Caveat

- Synchronous bug in plugged has been fixed with a workaround, but is not yet resolved. See https://github.com/junegunn/vim-plug/issues/104 .

## [2.0.0] - 2015-07-06

### Added

- Nvim config
- Better folder layout
- Fish Config

### Removed

- Empty screenrc
- Vim Config
- Zsh Config

## [1.0.0] 2015-07-03

### Added

- Added cool custom prompt

### Removed

- Removed Oh-My-Zsh

## [0.0.1] - 2015-05-12

First official release! Wooho
