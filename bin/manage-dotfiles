#!/usr/bin/env fish
set session dotfiles

if tmux has-session -t "$session"
    tmux attach -t "$session"
    exit 0
end

tmux new-session -c "$DOTFILES" -d -s "$session" -n "Dotfilezzzz" "nvim"

tmux split-window -c "$DOTFILES" -t "$session:0"

tmux send-keys -t "$session:0" "dotfiles" C-m

tmux attach -t "$session"
