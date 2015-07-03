#!/bin/bash
# Aliases
# =======
# Git aliases
# ===========
# Adding files
# ------------
alias ga='git add'
alias gm='git commit'
alias gma='git commit -am'
alias gc='git checkout'

# Dealing with remote
# -------------------
alias gcl='git clone'
alias gp='git push'
alias gpu='git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`'
alias gpl='git pull'
alias gcl='git clone'
{
# shellcheck disable=SC2016
alias gtrack='for remote in $(git branch -r | grep -v master); do git checkout --track $remote ; done'
}

# Swiss knives
# ------------
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gp='git push || git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`'
# http://stackoverflow.com/a/379842
alias gtrack='for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master`; do  git branch --track ${branch##*/} $branch; done'
# shellcheck disable=SC2142
alias git_prune='git branch -vv | grep gone | awk "{print $1}" | xargs git branch -d'
alias changelog='git commit CHANGELOG.md -m "DOC: Update Changelog"'

# Genesis
# -------
alias gi='git init && touch .gitignore && git add . && git commit -a -m "Initial commit"'


# SSH Aliases
# ===========
alias ssh-x='ssh -c arcfour,blowfish-cbc -XC'
alias gruenau='ssh-x -t perlwitj@gruenau.informatik.hu-berlin.de zsh'


# Python Aliases
# =============
alias pip_freeze='pip freeze -r requirements.txt > requirements.txt'
alias pip_install='pip install -r requirements.txt'
alias create_env='virtualenv -p=python3.4.1 env'
alias s_env='source env/bin/activate'


# Latex Aliases
# =============
alias latexmk='latexmk -pdf -pvc'


# Other Aliases
# =============
alias ed='ed -p:'
alias hosts='sudo vim /etc/hosts'
alias flushcache='sudo dscacheutil -flushcache'
alias evim='vim ~/.vimrc'
alias ezsh='vim ~/.zshrc'
alias dotfiles='cd ~/.dotfiles'
alias clock='watch -t -n1 "date | figlet -k"'
alias rm='rm'
