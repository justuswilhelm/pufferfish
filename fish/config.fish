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
# Clean abbreviations
set -e fish_user_abbreviations

# Fish
# ----
# Reload fish sesseion. Useful if config.fish has changed.
abbr -a reload exec fish

# Files
# -----
# Make it easier to ls a folder by saving one character.
abbr -a l ls

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
abbr -a gi 'git init; and git commit --allow-empty -m "Initial commit"'
abbr -a gl git log
abbr -a gm git commit
abbr -a gma git commit --amend
abbr -a gmm git commit -m
abbr -a gp git push
abbr -a gpf git push --force
abbr -a gpr git pull --rebase
abbr -a gpu 'git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'
abbr -a gr git remote
abbr -a gra git rebase --abort
abbr -a grc git rebase --continue
abbr -a gri git rebase -i
abbr -a gro 'git fetch --all; and git rebase origin/master'
abbr -a groh git reset origin/master --hard
abbr -a gs git status

# Python
# ------
abbr -a pi pip install
abbr -a pir pip install -r requirements.txt
abbr -a s source env/bin/activate.fish

# tmux
# ----
abbr -a t tmux
abbr -a ta tmux a

# Neovim
# -----
abbr -a e nvim
