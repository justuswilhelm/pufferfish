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
  alias gp "git push; or git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`"
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

# Dotfiles
# =======
  alias dotfiles "pushd; cd ~/.dotfiles"
