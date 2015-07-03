#!/bin/bash
DOTFILES=~/.dotfiles
MODULES=("colors" "complist" "compinit" "zutil")
EXECUTE_MODULES=("colors" "compinit")
SOURCE_FILES=("alias.zsh" "helpers.zsh" "prompt.zsh")

# shellcheck disable=SC2128
function load_modules() {
  for module in $MODULES
  do
    autoload -U "$module"
  done
  for module in $EXECUTE_MODULES
  do
    $module
  done
}

function source_files() {
  # shellcheck disable=SC2128
  for source_file in $SOURCE_FILES
  do
    source "$DOTFILES/$source_file"
  done
}

load_modules
source_files
