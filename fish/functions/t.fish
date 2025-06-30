function t -d "(tmux) Create a new tmux session with the given name" -a name
    if [ -n "$name" ]
        set session_name $name
    else
        echo "Assuming session name is current directory name"
        set session_name (basename $PWD)
    end

    set session_name (string replace . _ $session_name)
    echo "Session name is" $session_name

    if ! tmux new-session -d -s $session_name
        echo "Couldn't create new tmux session $session_name"
        return 1
    end

    if ! tsa $session_name
        echo "Couldn't tsa to session $session_name"
    end
end
