function t-cmus -d "Launch cmus in a tmux session"
    set session cmus
    # This could be a universal variable as well
    set music "$HOME/Music/Music_Files"

    if tmux has-session -t $session
        tsa $session
        return
    end

    tmux new-session -c $HOME/Music/Music_Files -d -s $session -n cmus
    tmux send-keys -t $session:0 cmus C-m

    tsa $session
end
