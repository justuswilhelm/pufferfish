# Paths
# =====
#
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

add_to_path "$HOME/bin"
add_to_path "$HOME/go/bin"

if is_darwin
    add_to_path "/usr/local/texlive/2016/bin/x86_64-darwin"
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
abbr -a gds git diff --shortstat --cached
abbr -a gfa git fetch --all
abbr -a gl git log
abbr -a gm git commit
abbr -a gma git commit --amend
abbr -a gmm git commit -m
abbr -a gpf git push --force
abbr -a gpr git pull --rebase
abbr -a gr git remote
abbr -a gra git rebase --abort
abbr -a grc git rebase --continue
abbr -a gro "git fetch --all; and git rebase origin/master"
abbr -a gs git status

# Heroku
# ======
abbr -a hmo heroku maintenance:off
abbr -a hmon heroku maintenance:on

# Python
# ======
abbr -a doctest python -m doctest
abbr -a pi pip install
abbr -a pir pip install -r requirements.txt
abbr -a pm python -m
abbr -a s source env/bin/activate.fish
abbr -a p2f nvim $DOTFILES/python/requirements2.txt
abbr -a pf nvim $DOTFILES/python/requirements.txt

# tmux
# ====
abbr -a t tmux
abbr -a ta tmux a

# Neovim
# =====
abbr -a e nvim
