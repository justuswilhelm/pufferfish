#!/bin/bash
if ! files=$(git diff --cached --name-only)
then
    echo "Nothing is staged"
    exit 1
fi
# Last 10 commit subjects, commented out
if ! message=$(git log --pretty=%s -- $files | head -n10 | sed -e 's/^/# /')
then
    echo "Couldn't get log for these files:
    $files
    "
    exit 1
fi

git commit --edit --message "

# Commit message suggestions:
# ---------------------------
#
$message"
