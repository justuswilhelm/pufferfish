function commit -d "Suggest git commit messages based on previous commit messages of staged files"
    set files (git diff --cached --name-only) || begin
        echo "Nothing is staged"
        return 1
    end

    # Last 10 commit subjects, commented out
    set commit_template (mktemp)
    begin
        echo "\
# Commit message suggestions:
# ---------------------------
#"
        git log --pretty=%s -- $files | head -n10 | sed -e 's/^/# /' || return 1
    end > $commit_template
    if [ $status -ne 0 ]
        echo "Couldn't get log for these files:
$files"
        return 1
    end

    git commit --template=$commit_template
end
