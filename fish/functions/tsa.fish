function tsa
    set session "$argv[1]"
    if set -q TMUX
        echo "Already in tmux, switching to $session"
        tmux switch-client -t "$session"
    else
        echo "Attaching to $session"
        tmux attach-session -t "$session"
    end
end
