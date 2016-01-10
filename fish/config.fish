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
alias gma "git commit --amend"
alias gs "git status"

# Python
# ======
alias pip_install "pip install -r requirements.txt"
alias s_env "source env/bin/activate.fish"

# Other
# =====
alias hosts "sudo vim /etc/hosts"
alias latexmk "latexmk -pdf -pvc"
alias ssh-x "ssh -c arcfour,blowfish-cbc -XC"
alias vim "nvim"
alias dotfiles "cd ~/.dotfiles"

# Homebrew
set PATH $PATH /usr/local/bin:/usr/local/sbin

# Heroku toolbelt
set PATH $PATH /usr/local/heroku/bin

# MacTex
set PATH $PATH /usr/local/texlive/2014basic/bin/x86_64-darwin/

# Local Bin
set PATH $PATH ~/bin

if [ -f /usr/local/share/autojump/autojump.fish ]
  source /usr/local/share/autojump/autojump.fish
end

if isatty
  cd .
end
