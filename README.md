# pufferfish

![pufferfish](docs/puffer.png)

Add useful defaults and configuration files for

- Nix,
- tmux,
- neovim,
- fish,
- and many more.

## Using on macOS

- [Nix](https://nixos.org/download#download-nix), and
- [nix darwin](https://github.com/LnL7/nix-darwin)

Initial installation:

```
git clone git@github.com:justuswilhelm/pufferfish.git "$HOME/.dotfiles"
darwin-rebuild switch --flake "$HOME/.dotfiles/nixpkgs"
```

Rebuild:

```
darwin-rebuild switch --flake "$HOME/.dotfiles/nixpkgs"
```

## Using on Debian

Requirements are:

- [Nix](https://nixos.org/download#download-nix), and
- [home manager](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)

Furthermore, to properly use the window manager, you need to have installed (using apt)

- sway
- swaylock
- swayidle

All other dependencies will be installed using home manager.

Initial installation:

```
git clone git@github.com:justuswilhelm/pufferfish.git "$HOME/.dotfiles"
home-manager --extra-experimental-features flakes --extra-experimental-features nix-command switch --flake $HOME/.dotfiles/home-manager
```

Rebuild:

```
home-manager switch --flake $DOTFILES/home-manager
```

## How to report a bug

You can file an issue
[here](https://github.com/justuswilhelm/pufferfish/issues/new)

## How to contribute code

I am happy about accepting new contributions into this repository. You can file
a pull request right
[here](https://github.com/justuswilhelm/pufferfish/compare).

The best way to get started is by forking this repository and developing a new
feature or bug fix on your own repository. Then, you can create a pull request
to contribute the code back.

# License

Copyright (c) 2014-2024 Justus Perlwitz

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <https://www.gnu.org/licenses/>.

# Credits

- Iosevka (`fonts/`): SIL Open Font License v1.1, refer to `fonts/LICENSE.md`
- 24-bit-color (`bin/24-bit-color`): GPL v2, https://github.com/gnachman/iTerm2/blob/master/LICENSE
- neovim selenized colors (`nvim/colors/selenized.vim`): MIT License, see `nvim/colors/LICENSE.txt`
- iterm2 selenized colors (`selenized/terminals/iterm`): MIT License, see `selenized/LICENSE.txt`
