#!/bin/zsh
# Oh-My-Zsh specific code
# =======================
  # shellcheck disable=SC2034
  {
    ZSH=$HOME/.dotfiles/oh-my-zsh
    ZSH_THEME="sunrise"
    export UPDATE_ZSH_DAYS=3
    COMPLETION_WAITING_DOTS="true"
    plugins=(git brew autojump zsh-syntax-highlighting)
    source "$ZSH/oh-my-zsh.sh"
  }


# Grab some additional helpful helpers
# ====================================
if [[ $(uname) == 'Darwin' ]]
  then
    [[ -s "$(brew --prefix)/etc/autojump.sh" ]] && . "$(brew --prefix)/etc/autojump.sh"
  fi


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


# PATH adjustments for Homebrew
# =============================
  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/local/bin:$PATH

  if [[ -e local_root ]]
  then
    export PATH=$HOME/local_root/usr/local/bin/:$PATH
  fi

# PATH adjustment for Heroku toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


# Other environ paths
# =========================
  export GOPATH=$HOME/code
  export TERM='xterm-256color'

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


# What to execute in the beginning
# ================================
# =======================
# Set Apple Terminal.app resume directory
if [[ $TERM_PROGRAM == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]
then
{
  function chpwd {
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]7;%s\a' "$PWD_URL"
  }

  chpwd
}
fi
cd .

export LANG=en_US.UTF-8
