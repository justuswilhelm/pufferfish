# Paths
# =====
function add_to_path
    if not test -d $argv[1]
        return
    end
    if not contains $argv[1] $PATH
        set PATH $PATH $argv[1]
    end
end

set -x DOTFILES "$HOME/.dotfiles"
set -x EDITOR "nvim"
set -x GOPATH "$HOME/go"
set -x TERM "xterm-256color"
set -x XDG_CONFIG_HOME "$HOME/.config"

add_to_path "/usr/local/sbin"
add_to_path "$HOME/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/go/bin"

# Abbreviations
# =============
# Clean abbreviations
set -e fish_user_abbreviations

# Fish abbreviations
# ------------------
# Reload fish session. Useful if config.fish has changed.
abbr -a reload exec fish

# File abbreviations
# ------------------
# Make it easier to ls a folder by saving one character.
abbr -a l ls
# Re-cd to the current directory. Useful if inode was changed.
abbr -a cdp 'cd $PWD'

# Homebrew abbreviations
# ----------------------
# Perform a full update/upgrade cycle
abbr -a bbbbb 'brew update; and brew upgrade; and brew cask upgrade; and brew cleanup -s; and brew cask cleanup'

# Homebrew abbreviations
# ----------------------
# Perform a full update/upgrade cycle
abbr -a bbbb 'brew update; and brew upgrade; and brew cleanup -s; and brew cask cleanup'

# Git abbreviations
# -----------------
# Stage changed files in git index
abbr -a ga git add
# Stage changes in files in patch mode
abbr -a gap git add -p
# Check out a branch or file
abbr -a gc git checkout
# Check out a new branch
abbr -a gcb git checkout -b
# Cherry pick
abbr -a gcp git cherry-pick
# Continue cherry picking
abbr -a gcpc git cherry-pick --continue
# Show the current diff for unstaged changes
abbr -a gd git diff
# Show the current diff for staged changes
abbr -a gdc git diff --cached
# Show commit statistics for staged changes
abbr -a gds git diff --shortstat --cached
# Fetch from all remote branches
abbr -a gfa git fetch --all
# Initialize an empty repository
abbr -a gi 'git init; and git commit --allow-empty -m "Initial commit"'
# Show the git log
abbr -a gl git log
# Show the git log in patch mode
abbr -a glp git log -p
# Commit the current staged changes
abbr -a gm git commit
# Amend to the previous commit
abbr -a gma git commit --amend
# Commit the current staged changes with a message
abbr -a gmm git commit -m
# Push to remote
abbr -a gp git push
# Push to remote and force update (potentially dangerous)
abbr -a gpf git push --force
# Bring current branch up to date with a rebase
abbr -a gpr git pull --rebase
# Push and create branch if it has not yet been created remotely
abbr -a gpu 'git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'
# Show remote repositories
abbr -a gr git remote
# Abort a rebase
abbr -a gra git rebase --abort
# Continue with the next rebase step
abbr -a grc git rebase --continue
# Perform interactive rebase
abbr -a gri git rebase -i
# Rebase current branch from origin master
abbr -a gro 'git fetch --all; and git rebase origin/master'
# Reset current branch to origin master (dangerous)
abbr -a groh git reset origin/master --hard
# Show current status
abbr -a gs git status

# Python abbreviations
# --------------------
# Install a package with pip
abbr -a pi pip install
# Install requirements with pip based on requirements.txt
abbr -a pir pip install -r requirements.txt
# Activate virtual env in env/bin/activate.fish
abbr -a s source env/bin/activate.fish
# Call Jupyter notebook
abbr -a jn jupyter notebook

# tmux abbreviations
# ------------------
# Start tmux
abbr -a t tmux
# Attach to existing session
abbr -a ta tmux a

# Neovim abbreviations
# --------------------
# Start neovim
abbr -a e nvim
