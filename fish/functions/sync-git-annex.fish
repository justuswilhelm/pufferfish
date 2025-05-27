function sync-git-annex -a remote
    if [ -n "$remote" ]
        echo "Syncing with remote '$remote'"
    else
        echo "Syncing with all remotes"
    end
    if not set paths (
        fd --exclude "$HOME/.cache" \
            --exclude $HOME/Library \
            --prune \
            --hidden --full-path $HOME'/.*/.git/annex$' $HOME
    )
        echo "Couldn't retrieve git-annex paths"
    end
    echo "Found $(count paths) git-annex repositories"
    for annex_sub_dir in $paths
        set annex (dirname (dirname $annex_sub_dir))
        if ! git -C $annex remote get-url $remote
            echo "git-annex at '$annex' has not remote named '$remote'"
            continue
        end
        echo "Sync git-annex at '$annex'"
        set command "cd $annex && git annex sync --content --no-commit $remote"
        echo "Running the following command:"
        echo "$command"
        if fish --command "$command"
            echo "Sync git-annex for '$annex' ok"
        else
            echo "Sync git-annex for '$annex' not ok"
            if ! read --prompt-str "Continue? C-c to quit>"
                return
            end
        end
    end
end
