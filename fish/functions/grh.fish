function grh
    set -l pointer "HEAD~$argv[1]"
    echo "Rebasing to $pointer"
    git rebase -i "$pointer"
end
