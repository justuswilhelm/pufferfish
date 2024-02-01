#!/usr/bin/env fish
set session tomato

if tmux has-session -t "$session"
    tsa "$session"
    return
end

tmux new-session -c "$HOME" -d -s "$session" -n "Tomato"

tmux send-keys -t "$session" "watch timew summary" C-m

tmux split-window -c "$HOME" -t "$session:0" -h

tsa "$session"
