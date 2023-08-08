#!/usr/bin/env fish
set -x FZF_DEFAULT_COMMAND "fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git"
set p (fzf)
exec nnn "$p"
