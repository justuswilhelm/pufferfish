function jump
    # If we are inside a git repo we want to jump relative to current dir
    if git rev-parse --is-inside-work-tree &>/dev/null
        set where (git rev-parse --show-toplevel)
    else
        set where $PWD
    end
    if ! set dest (fd --type d . $where | fzf --scheme=path)
        echo "Must specify destination"
        return 1
    end
    cd "$dest"
end
