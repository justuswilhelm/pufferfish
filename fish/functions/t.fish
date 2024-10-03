function t -d "Create a new tmux session with the given name" -a name
    if [ -n "$name" ]
        set session_name $name
    else
        echo "Assuming session name is current directory name"
        set session_name (basename $PWD)
    end
    if ! tmux new-session -d -s $session_name
        echo "Couldn't create new tmux session $session_name"
        return 1
    end
    if ! tsa $session_name
        echo "Couldn't tsa to session $session_name"
    end
end
