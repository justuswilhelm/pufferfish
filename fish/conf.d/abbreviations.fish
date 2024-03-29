# Abbreviations
# =============
#
# Fish abbreviations
# ------------------
# Reload fish session. Useful if config.fish has changed.
abbr -a reload exec fish

# File abbreviations
# ------------------
# Ls shortcut with color, humanized, list-based output
abbr -a l ls -lhaG

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
# Abort cherry pick
abbr -a gcpa git cherry-pick --abort
# Continue cherry picking
abbr -a gcpc git cherry-pick --continue
# Show the current diff for unstaged changes
abbr -a gd git diff
# Show the current diff for staged changes
abbr -a gdc git diff --cached
# Show commit statistics for staged changes
abbr -a gds git diff --shortstat --cached
# Fetch from default remote branch
abbr -a gf git fetch
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
abbr -a gmm git commit -e -m
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
# Perform interactive rebase on origin/master
abbr -a grio git rebase -i origin/master
# Perform interactive rebase on origin/main
abbr -a griom git rebase -i origin/main
# Perform interactive rebase on origin/development
abbr -a griod git rebase -i origin/development
# Rebase current branch from origin/master
abbr -a gro 'git fetch --all; and git rebase origin/master'
# Rebase current branch from origin/development
abbr -a grod 'git fetch --all; and git rebase origin/development'
# Reset current branch to origin master (dangerous)
abbr -a groh git reset origin/master --hard
# Rebase current branch from origin/master
abbr -a grom 'git fetch --all; and git rebase origin/main'
# Show current status
abbr -a gs git status

# Neovim abbreviations
# --------------------
# Start neovim
abbr -a e nvim
