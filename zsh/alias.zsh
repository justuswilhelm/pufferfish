#!/bin/bash
# Aliases
# =======

# Git aliases
# -----------
  alias ga='git add'
  alias gap='git add -p'
  alias gm='git commit'
  alias gc='git checkout'
  alias gl='git log'
  alias gs='git status'
  alias gd='git diff'
  alias gp='git push || git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`'
  # http://stackoverflow.com/a/379842
  alias gtrack='for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master`; do  git branch --track ${branch##*/} $branch; done'
  # shellcheck disable=SC2142
  alias git_prune='git branch -vv | grep gone | awk "{print $1}" | xargs git branch -d'
  alias changelog='git commit CHANGELOG.md -m "DOC: Update Changelog"'

# SSH Aliases
# -----------
  alias ssh-x='ssh -c arcfour,blowfish-cbc -XC'

# Python Aliases
# -------------
  alias pip_install='pip install -r requirements.txt'
  alias create_env='virtualenv -p=python3.4.1 env'
  alias s_env='source env/bin/activate'

# Latex Aliases
# =============
  alias latexmk='latexmk -pdf -pvc'

# Other Aliases
# -------------
  alias hosts='sudo vim /etc/hosts'
  alias evim='vim ~/.vimrc'
  alias ezsh='vim ~/.zshrc'
  alias dotfiles='cd ~/.dotfiles'
