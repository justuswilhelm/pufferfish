function sync-git-annex
    if ! set -q GIT_ANNEX_PATHS
        echo "Must define GIT_ANNEX_PATHS"
        return 1
    end
    for annex in $GIT_ANNEX_PATHS
        echo "Sync $annex"
        fish -c "cd $annex && git annex sync --content"
        or return
    end
end
