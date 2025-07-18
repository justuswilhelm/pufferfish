function manage-dotfiles -d "Launch a tmux session to manage your dotfiles"
    set session dotfiles

    if tmux has-session -t $session
        tsa $session
        return
    end

    tmux new-session -c $DOTFILES -d -s $session -n Dotfilezzzz
    tmux send-keys -t "$session:0" nvim C-m

    tmux split-window -c $DOTFILES -h -t "$session:0"
    tmux send-keys -t "$session:0" "git status" C-m

    tsa $session
end
