function sync-git-annex
    for annex in "TODO"
        echo "Sync $annex"
        fish -c "cd $annex && git annex sync --content"
        or return
    end
end
