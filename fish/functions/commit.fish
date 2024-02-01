function commit -d "Suggest git commit messages based on previous commit messages of staged files"
    if ! set files (git diff --cached --name-only)
        echo "Nothing is staged"
        exit 1
    end
    # Last 10 commit subjects, commented out
    if ! set message (git log --pretty=%s -- $files | head -n10 | sed -e 's/^/# /')
        echo "Couldn't get log for these files:
        $files
        "
        exit 1
    end

    git commit --edit --message "

    # Commit message suggestions:
    # ---------------------------
    #
    $message"
end
