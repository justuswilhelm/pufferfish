# Git
# ===
alias changelog "git commit CHANGELOG.md -m 'DOC: Update Changelog'"
alias ga "git add"
alias gaa "git add -A"
alias gap "git add -p"
alias gc "git checkout"
alias gd "git diff"
alias gdc "git diff --cached"
alias gl "git log"
alias gm "git commit"
alias gme "git merge"
alias gmm "git commit -m"
alias gr "git remote"
alias gs "git status"

# Python
# ======
alias pi "pip install -r requirements.txt"
alias se "source env/bin/activate.fish"
alias pm "python -m"
alias doctest "python -m doctest"

# Other
# =====
alias vim "nvim"
alias dotfiles "cd ~/.dotfiles"
alias bf "nvim ~/.brewfile"
alias o "open"
alias suggest "history | cut -f1,2 -d' ' | uniq -c | sort -r | head -n10"

# Paths
# =====
# Homebrew
set PATH $PATH /usr/local/bin:/usr/local/sbin
set -x HOMEBREW_BREWFILE $HOME/.brewfile

# Heroku toolbelt
set PATH $PATH /usr/local/heroku/bin

# MacTex
set PATH $PATH /usr/local/texlive/2014basic/bin/x86_64-darwin/

# Local Bin
set PATH $PATH $HOME/bin

if status --is-interactive
  cd .
end
export TERM="xterm-256color"
