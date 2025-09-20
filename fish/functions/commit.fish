# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function commit -d "Suggest git commit messages based on previous commit messages of staged files"
    set git_root (git rev-parse --show-toplevel) || begin
        echo "Could not determine root"
        return 1
    end
    set files (git diff --cached --name-only $git_root) || begin
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
        git log --pretty=%s -- $git_root/$files | head -n10 | sed -e 's/^/# /' || return 1
    end >$commit_template
    if [ $status -ne 0 ]
        echo "Couldn't get log for these files:
$files"
        return 1
    end

    git commit --template=$commit_template
end
