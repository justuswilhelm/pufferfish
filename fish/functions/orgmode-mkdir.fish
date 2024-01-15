function orgmode-mkdir
    if ! set parent (fd --type d | sort | fzf)
        echo "Must select parent"
        return 1
    end
    echo "Existing folders are:"

    fd --type d . "$parent"

    if ! read -p "new dir $parent" new_dir
        echo "Must give directory name"
        return 1
    end

    mkdir -v "$parent$new_dir"
end
