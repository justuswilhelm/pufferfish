function td -d "Create a new tmux session in a given directory"
    set hist_file $XDG_STATE_HOME/pufferfish/td.hist
    mkdir -vp (dirname $hist_file)
    set dir (fd -t d | fzf --scheme=history --history=$hist_file)
    set session_name (basename $dir)
    tmux new-session -c $dir -s $session_name
end
