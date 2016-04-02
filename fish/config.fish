# Git
# ===
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
alias grs "git reset --soft HEAD~1"
alias gs "git status"

# Python
# ======
alias pi "pip install -r requirements.txt"
alias se "source env/bin/activate.fish"
alias pm "python -m"
alias doctest "python -m doctest"

# Other
# =====
alias bf "nvim ~/.brewfile"
alias pf "nvim $DOTFILES/python/requirements.txt"
alias p2f "nvim $DOTFILES/python/requirements2.txt"
alias bi "brew install"
alias binf "brew info"
alias o "open"
alias suggest "history | cut -f1,2 -d' ' | uniq -c | sort -r | head -n10"
alias t "tmux"
alias vim "nvim"

# Paths
# =====
# Homebrew
for p in "/usr/local/bin" "/usr/local/sbin" "/usr/local/heroku/bin" "$HOME/bin"
    set PATH $PATH $p
end

set -x HOMEBREW_BREWFILE $HOME/.brewfile
set -x TERM "xterm-256color"
set -x EDITOR "nvim"
set -x DOTFILES $HOME/.dotfiles
set -x XDG_CONFIG_HOME $HOME/.config
