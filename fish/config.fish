# Paths
# =====

set -x HOMEBREW_BREWFILE $HOME/.brewfile
set -x TERM "xterm-256color"
set -x EDITOR "nvim"
set -x DOTFILES $HOME/.dotfiles
set -x XDG_CONFIG_HOME $HOME/.config
set -x GOPATH $HOME/go

for p in "/usr/local/bin" "/usr/local/heroku/bin" "$HOME/bin" "$GOPATH/bin"
    set PATH $PATH $p
end

# Git
# ===
abbr -a ga git add
abbr -a ga git add
abbr -a gap git add -p
abbr -a gc git checkout
abbr -a gd git diff
abbr -a gdc git diff --cached
abbr -a gl git log
abbr -a gm git commit
abbr -a gmm git commit -m
abbr -a gr git remote
abbr -a gs git status
abbr -a gfa git fetch --all
abbr -a gpr git pull --rebase
abbr -a gpf git push --force

# Python
# ======
abbr -a pi pip install
abbr -a pir pip install -r requirements.txt
abbr -a se source env/bin/activate.fish
abbr -a pm python -m
abbr -a doctest python -m doctest

# Other
# =====
abbr -a bf nvim ~/.brewfile
abbr -a pf nvim $DOTFILES/python/requirements.txt
abbr -a p2f nvim $DOTFILES/python/requirements2.txt
abbr -a bi brew install
abbr -a binf brew info
abbr -a t tmux
abbr -a m tmuxinator
abbr -a vim nvim
abbr -a mt make test
