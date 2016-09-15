# Paths
# =====

set -x HOMEBREW_BREWFILE $HOME/.brewfile
set -x TERM "xterm-256color"
set -x EDITOR "nvim"
set -x DOTFILES $HOME/.dotfiles
set -x XDG_CONFIG_HOME $HOME/.config
set -x GOPATH $HOME/go

for p in "/usr/local/bin" "/usr/local/heroku/bin" "$HOME/bin"
    set PATH $PATH $p
end

# Git
# ===
abbr -a ga git add
abbr -a ga git add
abbr -a gap git add -p
abbr -a gc git checkout
abbr -a gcb git checkout -b
abbr -a gd git diff
abbr -a gdc git diff --cached
abbr -a gfa git fetch --all
abbr -a gl git log
abbr -a gm git commit
abbr -a gmm git commit -m
abbr -a gpf git push --force
abbr -a gpr git pull --rebase
abbr -a gr git remote
abbr -a gs git status
abbr -a gds git diff --shortstat --cached

# Python
# ======
abbr -a doctest python -m doctest
abbr -a pi pip install
abbr -a pir pip install -r requirements.txt
abbr -a pm python -m
abbr -a se source env/bin/activate.fish

# Other
# =====
abbr -a bf nvim ~/.brewfile
abbr -a bi brew install
abbr -a binf brew info
abbr -a m tmuxinator
abbr -a mt make test
abbr -a p2f nvim $DOTFILES/python/requirements2.txt
abbr -a pf nvim $DOTFILES/python/requirements.txt
abbr -a t tmux
abbr -a vim nvim
