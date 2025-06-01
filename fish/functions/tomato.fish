function tomato
    set session tomato

    if tmux has-session -t "$session"
        tsa "$session"
        return
    end

    tmux new-session -c "$HOME" -d -s "$session" -n Tomato
    tmux send-keys -t "$session" "watch timew summary :ids" C-m

    tmux split-window -c "$HOME" -t "$session:0" -h
    tmux send-keys -t "$session" "pomoglorbo" C-m

    tmux split-window -c "$HOME" -t "$session:0" -v
    tmux send-keys -t "$session" "timew" C-m

    tsa "$session"
end
