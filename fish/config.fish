# Git
# ===
alias changelog "git commit CHANGELOG.md -m 'DOC: Update Changelog'"
alias ga "git add"
alias gap "git add -p"
alias gc "git checkout"
alias gd "git diff"
alias gdc "git diff --cached"
alias gl "git log"
alias gm "git commit"
alias gs "git status"

# Python
# ======
alias pi "pip install -r requirements.txt"
alias se "source env/bin/activate.fish"

# Other
# =====
alias vim "nvim"
alias dotfiles "cd ~/.dotfiles"

# Homebrew
set PATH $PATH /usr/local/bin:/usr/local/sbin
set -x HOMEBREW_BREWFILE $HOME/.brewfile

# Heroku toolbelt
set PATH $PATH /usr/local/heroku/bin

# MacTex
set PATH $PATH /usr/local/texlive/2014basic/bin/x86_64-darwin/

# Local Bin
set PATH $PATH $HOME/bin

if [ -f /usr/local/share/autojump/autojump.fish ]
  source /usr/local/share/autojump/autojump.fish
end

if isatty
  cd .
end
