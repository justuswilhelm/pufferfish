#!/bin/bash
DOTFILES=~/.dotfiles
autoload -U zutil
autoload -U compinit
autoload -U complist
compinit
source $DOTFILES/alias.zsh
source $DOTFILES/environ.zsh
source $DOTFILES/helpers.zsh
source $DOTFILES/startup.zsh
