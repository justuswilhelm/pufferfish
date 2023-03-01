function dotfiles -d "Pull latest dotfiles from pufferfish repository"
    pushd $DOTFILES
    if not git pull --rebase origin main
        echo
        echo ---
        echo
        set_color green
        echo "Howdy dotfiles friend!"
        set_color normal
        echo
        echo "I could not pull the latest changes from the repository."
        echo "You might want to stash your changes and try running 'dotfiles'"
        echo "again."
    end
end
