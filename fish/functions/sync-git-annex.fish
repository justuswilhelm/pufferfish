function sync-git-annex
    if not set paths (
        fd --exclude "$HOME/.cache" \
            --exclude $HOME/Library \
            --prune \
            --hidden --full-path $HOME'/.*/.git/annex$' $HOME
    )
        echo "Couldn't retrieve git annex paths"
    end
    for annex_sub_dir in $paths
        set annex (dirname (dirname $annex_sub_dir))
        echo "Sync $annex"
        fish -c "cd $annex && git annex sync --content --no-commit"
        or return
    end
end
