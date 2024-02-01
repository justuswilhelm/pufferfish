function commit -d "Suggest git commit messages based on previous commit messages of staged files"
    set files (git diff --cached --name-only) || begin
        echo "Nothing is staged"
        return 1
    end

    # Last 10 commit subjects, commented out
    set message (git log --pretty=%s -- $files | head -n10 | sed -e 's/^/# /') || begin
        echo "Couldn't get log for these files:
$files
"
        return 1
    end

    git commit --edit --message "

# Commit message suggestions:
# ---------------------------
#
$message"
end
