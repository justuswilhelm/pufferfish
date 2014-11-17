# Oh-My-Zsh specific code
# =======================
  ZSH=$HOME/.dotfiles/oh-my-zsh
  export ZSH_THEME="agnoster"
  export UPDATE_ZSH_DAYS=3
  export COMPLETION_WAITING_DOTS="true"
  {
    # shellcheck disable=SC2034
    plugins=(git brew autojump zsh-syntax-highlighting)
  }
  source "$ZSH/oh-my-zsh.sh"


# Aliases
# =======
# Git aliases
# ===========
  # Adding files
  # ------------
    alias ga='git add -A'
    alias gm='git commit'
    alias gc='git checkout'

  # Dealing with remote
  # -------------------
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

  # Genesis
  # -------
    alias gi='git init && touch .gitignore && git add . && git commit -a -m "Initial commit"'


# SSH Aliases
# ===========
  alias ssh-x='ssh -c arcfour,blowfish-cbc -XC'
  alias gruenau='ssh-x -t perlwitj@gruenau.informatik.hu-berlin.de zsh'


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

  alias pip_freeze='pip freeze > requirements.txt'


# PATH adjustments for Homebrew
# =============================
  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/local/bin:$PATH

  if [[ -e local_root ]]
  then
    export PATH=$HOME/local_root/usr/local/bin/:$PATH
  fi


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

  # OSPI I relevant
  # ---------------
  svnupdate() {
    echo " -- Updating files"
    j 2014
    svn update
    echo " -- Returning!"
    cd -
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


# What to execute in the beginning
# ================================
