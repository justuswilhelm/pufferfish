function blog
    set session blog
    set cwd "$HOME/projects/personal-website"

    # Attach if already created
    if tmux has-session -t $session
        tsa $session
        return
    end
    tmux new-session -c $cwd -d -s $session
    tmux send-keys -t $session "nvim" C-m
    tmux split-window -c $cwd -h -t $session
    tmux send-keys -t $session "git status" C-m

    tsa $session
end
