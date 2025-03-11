function blog
    set session blog
    set cwd "$HOME/projects/personal-website"

    # Attach if already created
    if tmux has-session -t $session
        tsa $session
        return
    end

    tmux new-session -c $cwd -d -s $session -n editor
    tmux send-keys -t $session:editor "nvim" C-m
    tmux split-window -c $cwd -h -t $session
    tmux send-keys -t $session:editor "git status" C-m

    tmux new-window -c $cwd -t $session -n hugo_preview
    tmux send-keys -t $session:hugo_preview 'hugo server -D --destination (mktemp -d)' C-m

    # Go to first window
    tmux select-window -t $session:editor

    tsa $session
end
