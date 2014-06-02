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

alias ssh-x='ssh -c arcfour,blowfish-cbc -XC'

alias mex='chmod +x'

alias latexmk='latexmk -pdf -pvc'

source /Users/justusperlwitz/.rvm/scripts/rvm
[[ -s /usr/local/etc/autojump.sh ]] && . /usr/local/etc/autojump.sh
source /usr/local/opt/autoenv/activate.sh

export PATH=/usr/local/sbin:$PATH

