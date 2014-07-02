# Oh-My-Zsh specific code
# =======================
  ZSH=$HOME/.dotfiles/oh-my-zsh
  ZSH_THEME="af-magic"
  export UPDATE_ZSH_DAYS=3
  COMPLETION_WAITING_DOTS="true"
  plugins=(git brew autojump)
  source $ZSH/oh-my-zsh.sh

# Grab some additional helpful helpers
# ====================================
  source /Users/justusperlwitz/.rvm/scripts/rvm
  [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
  source /usr/local/opt/autoenv/activate.sh

# Aliases
# =======
# Git aliases
# ===========
  # Adding files
  # ------------
  alias ga='git add -A'
  alias gm='git commit -m'
  alias gma='git commit -am'
  alias gc='git checkout'

  # Dealing with remote
  # -------------------
  alias gp='git push'
  alias gpu='git pull'
  alias gcl='git clone'

  # Swiss knives
  # ------------
  alias gl='git log'
  alias gs='git status'
  alias gd='git diff'

  # Genesis
  # -------
  alias gi='git init'

# SSH Aliases
# ===========
  alias ssh-x='ssh -c arcfour,blowfish-cbc -XC'

# Latex Aliases
# =============
  alias latexmk='latexmk -pdf -pvc'

# Other Aliases
# =============
  alias ed='ed -p:'
  alias hosts='sudo vim /etc/hosts'
  alias flushcache='sudo dscacheutil -flushcache'
  alias gruenau='ssh perlwitj@gruenau.informatik.hu-berlin.de'

# PATH adjustments for Homebrew
# =============================
  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/local/bin:$PATH

# Other environ paths
# =========================
  export GOPATH=$HOME/code

# Helpful helpers
# ===============
  # Make file executable, create it if it does not exist
  # ----------------------------------------------------
  mex() {
    if ! [ -e $1 ]
    then
      touch $1
      chmod +x $1
    else
      echo "File $1 already exists!"
      echo "Changing $1 to +x"
      chmod +x $1
    fi
  }

  # Make dir and change to it
  # -------------------------
  mcd() {
    mkdir $1 && cd $1
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

# What to execute in the beginning
# ================================
