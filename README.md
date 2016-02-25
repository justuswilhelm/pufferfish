# Dotfiles

## Quickstart

Run

```
script/bootstrap
```

and follow the instructions.


## Requirements

+ NeoVim
+ `fish` shell
+ git

## Fish configuration

See `fish/README.md` for more information.

## Brewfile
```
curl -fsSL https://raw.github.com/rcmdnk/homebrew-file/install/install.sh |sh
```

## Ubuntu Wily
```
yes | sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y git fish ruby mosh build-essential python-setuptools python3 python3-pip neovim curl tmux finger
yes | git clone git@github.com:justuswilhelm/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```
