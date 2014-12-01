#!/bin/zsh
# Oh-My-Zsh specific code
# =======================
  # shellcheck disable=SC2034
  {
    ZSH=$HOME/.dotfiles/oh-my-zsh
    ZSH_THEME="agnoster"
    export UPDATE_ZSH_DAYS=3
    COMPLETION_WAITING_DOTS="true"
    plugins=(git brew autojump zsh-syntax-highlighting)
    source "$ZSH/oh-my-zsh.sh"
  }


# Grab some additional helpful helpers
# ====================================
if [[ $(uname) == 'Darwin' ]]
  then
    source /Users/justusperlwitz/.rvm/scripts/rvm
    [[ -s "$(brew --prefix)/etc/autojump.sh" ]] && . "$(brew --prefix)/etc/autojump.sh"
    source /usr/local/opt/autoenv/activate.sh
  fi


# Aliases
# =======
# Git aliases
# ===========
  # Adding files
  # ------------
    alias ga='git add'
    alias gm='git commit -m'
    alias gma='git commit -am'
    alias gc='git checkout'

  # Dealing with remote
  # -------------------
    alias gcl='git clone'

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

  # Genesis
  # -------
    alias gi='git init'


# SSH Aliases
# ===========
  alias ssh-x='ssh -c arcfour,blowfish-cbc -XC'
  alias gruenau='ssh-x perlwitj@gruenau.informatik.hu-berlin.de'


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
  alias rm='rm -i'


# PATH adjustments for Homebrew
# =============================
  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/local/bin:$PATH

  if [[ -e local_root ]]
  then
    export PATH=$HOME/local_root/usr/local/bin/:$PATH
  fi


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
    mkdir "$1" && cd "$1"
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
    echo "source env/bin/activate" > .env
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


# What to execute in the beginning
# ================================

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
