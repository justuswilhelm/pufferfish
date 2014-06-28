# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="af-magic"

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=3

COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git nyan autojump)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
alias ga='git add -A'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gc='git checkout'
alias gpu='git pull'
alias gcl='git clone'
alias gi='git init'

alias ssh-x='ssh -c arcfour,blowfish-cbc -XC'

alias latexmk='latexmk -pdf -pvc'

alias ed='ed -p:'

source /Users/justusperlwitz/.rvm/scripts/rvm
[[ -s `brew --prefix`/etc/autojump.sh ]] \
  && . `brew --prefix`/etc/autojump.sh
source /usr/local/opt/autoenv/activate.sh

export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH

# Helpful helper
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

mcd() {
  mkdir $1 && cd $1
}

svnupdate() {
  echo " -- Updating files"
  j 2014
  svn update
  echo " -- Returning!"
  cd -
}
