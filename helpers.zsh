#!/bin/bash
# Helpful helpers
# ===============
# Make file executable, create it if it does not exist
# ----------------------------------------------------
mex() {
  if ! [ -e "$1" ]
  then
    touch "$1"
    chmod +x "$1"
  else
    echo "File $1 already exists!"
    echo "Changing $1 to +x"
    chmod +x "$1"
  fi
}

# Make dir and change to it
# -------------------------
mcd() {
  mkdir -p "$1" && cd "$1"
}

config() {
  dotfiles=~/.dotfiles
  echo " -- Going to $dotfiles"
  cd $dotfiles
  ./config
  cd -
  echo " -- Done!"
}

makeenv() {
  echo "Making a virtual environment with python $1"
  virtualenv -p "$1" env
  if ! [ -e .env ]
  then
    echo "source env/bin/activate" > .env
  fi
  cd .
}
# Overwrite cd
# ------------
cd() {
  builtin cd "$1"
  if [ -e ".env" ]
  then
    source .env
  fi
}

# Tag with newest changelog release no.
# -------------------------------------
git_tag() {
  git tag "$(awk '$1 == "##" {print $2;exit}' < CHANGELOG.md)"
}
