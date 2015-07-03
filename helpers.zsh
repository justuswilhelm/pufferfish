#!/bin/bash
# Helpful helpers
# ===============
# Make executable files, make files executable
# --------------------------------------------
mex() {
  if ! [ -e "$1" ]
  then
    touch "$1"
  else
    echo "File $1 already exists!"
  fi
  echo "Changing $1 to +x"
  chmod +x "$1"
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
  source env/bin/activate
}
# Overwrite cd
# ------------
cd() {
  builtin cd "$1"
  if [ -e "env/bin/activate" ]
  then
    source env/bin/activate
  fi
}

# Better git init
# ---------------
# shellcheck disable=SC2128,2086
gi() {
  files=("README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md")
  touch $files
  git add $files
}

# Tag with newest changelog release no.
# -------------------------------------
git_tag() {
  git tag "$(awk '$1 == "##" {print $2;exit}' < CHANGELOG.md | egrep -e '(\d+\.\d+\.\d+)' -o)"
}
