function jump
    if ! set dest (fd --type d | fzf)
        echo "Must specify destination"
        return 1
    end
    cd "$dest"
end
