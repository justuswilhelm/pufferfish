# Pufferfish

![pufferfish](docs/puffer.png)

Pufferfish gives you useful defaults and configuration files for the following
programs:

- Nix,
- NixOS,
- macOS,
- tmux,
- neovim,
- fish,
- neomutt,
- vdirsyncer,
- radicale,
- borgmatic,
- and many more.

You can install and use Pufferfish on macOS and NixOS. Pufferfish also works on
Debian, but additional installation steps may be necessary.

## Use Pufferfish on macOS

- [Nix](https://nixos.org/download#download-nix), and
- [nix-darwin](https://github.com/LnL7/nix-darwin)

Here's how you can install nix-darwin and Pufferfish from scratch.

1. Install nix on macOS using the [official installer](https://nixos.org/download#download-nix).
2. Clone this repository into your home directory at `$HOME/.dotfiles".
3. Add your machine to the `flake.nix` file in the repository root.
4. Run `darwin-rebuild` on the Nix flake contained in this repository.
Read more about `darwin-rebuild` [here](https://github.com/nix-darwin/nix-darwin?tab=readme-ov-file#getting-started).

Here's how you can clone this repository into the right directory:

```fish
git clone git@github.com:justuswilhelm/pufferfish.git "$HOME/.dotfiles"
```

When you've cloned the repository, run the following to install Pufferfish
with `darwin-rebuild`:

```fish
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "$HOME/.dotfiles"
```

### How to add your machine to the flake file

TODO

### How to rebuild Pufferfish

In a fish shell, run the following function:

```fish
rebuild
```

## Use Pufferfish on NixOS

TODO

## Use Pufferfish on Debian

You need to install the following programs to use Pufferfish on Debian:

- [Nix](https://nixos.org/download#download-nix), and
- [home manager](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)

Furthermore, make sure that you've installed the following programs using `apt`:

- sway
- swaylock
- swayidle

Pufferfish installs all other dependencies using `home-manager`.

Here's how to install Pufferfish from scratch:

```fish
git clone git@github.com:justuswilhelm/pufferfish.git "$HOME/.dotfiles"
home-manager --extra-experimental-features flakes --extra-experimental-features nix-command switch --flake $HOME/.dotfiles
```

Here's how to rebuild Pufferfish:

```fish
# In fish run the following function
rebuild
```

## Formatting the code

There is a nix flake in the root directory that installs the `prettier` command. Inside
a `nix develop` shell run the following:

```fish
prettier --check .
```

If you want to format everything, try the following command:

```fish
prettier --write .
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

Copyright (c) 2014-2025 Justus Perlwitz

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.

# Credits

- Iosevka (`fonts/`): SIL Open Font License v1.1, refer to `fonts/LICENSE.md`
- 24-bit-color (`bin/24-bit-color`): GPL v2, https://github.com/gnachman/iTerm2/blob/master/LICENSE
- neovim selenized colors (`nvim/colors/selenized.vim`): MIT License, see `nvim/colors/LICENSE.txt`
- iterm2 & alacritty selenized colors (`selenized/terminals/iterm`): MIT License, see `selenized/LICENSE.txt`
