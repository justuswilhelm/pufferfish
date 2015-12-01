# Change Log
Written according to [http://keepachangelog.com](Keep a Changelog). Uses
semantic versioning.

## [Unreleased]

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
