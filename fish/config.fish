# Paths
# =====
function add_to_path
    if not contains $argv[1] $PATH
        set PATH $PATH $argv[1]
    end
end

set -x TERM "xterm-256color"
set -x EDITOR "nvim"
set -x DOTFILES $HOME/.dotfiles
set -x XDG_CONFIG_HOME $HOME/.config
set -x GOPATH $HOME/go

add_to_path "/usr/local/sbin"
add_to_path "$HOME/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/go/bin"

# Abbreviations
# =============

# Fish
# ----
abbr -a reload 'exec fish'

# Files
# -----
abbr -a l ls

# Crypto
# ------
pbcopy <~/.ssh/id_rsa.pub

# Network
# -------
abbr -a random_mac 'openssl rand -hex 6 | sed \'s/\(..\)/\1:/g; s/.$//\''

# Git
# ---
abbr -a ga git add
abbr -a gap git add -p
abbr -a gc git checkout
abbr -a gcb git checkout -b
abbr -a gd git diff
abbr -a gdc git diff --cached
abbr -a gds git diff --shortstat --cached
abbr -a gfa git fetch --all
abbr -a gl git log
abbr -a gm git commit
abbr -a gma git commit --amend
abbr -a gmm git commit -m
abbr -a gp git push
abbr -a gpf git push --force
abbr -a gpr 'git pull --rebase'
abbr -a gpu 'git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'
abbr -a gr git remote
abbr -a gra git rebase --abort
abbr -a grc git rebase --continue
abbr -a gri git rebase -i
abbr -a gro 'git fetch --all; and git rebase origin/master'
abbr -a groh 'git reset origin/master --hard'
abbr -a gs git status
abbr -a gi 'git init; and git commit --allow-empty -m "Initial commit"'

# Python
# ------
abbr -a doctest python -m doctest
abbr -a pi pip install
abbr -a pir pip install -r requirements.txt
abbr -a pm python -m
abbr -a s source env/bin/activate.fish
abbr -a p2f nvim $DOTFILES/python/requirements2.txt
abbr -a pf nvim $DOTFILES/python/requirements.txt

# tmux
# ----
abbr -a t tmux
abbr -a ta tmux a

# Neovim
# -----
abbr -a e nvim

# Crontab
# -------
abbr -a cr env VIM_CRONTAB=true /usr/bin/env crontab
