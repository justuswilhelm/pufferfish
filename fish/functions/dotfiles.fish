function dotfiles -d "Navigate to dotfiles directory"
    pushd $DOTFILES
    set_color green
    echo "Howdy dotfiles friend!"
    set_color normal
    echo "You may want to pull in the latest changes using"
    set_color blue
    echo "git pull --rebase origin"
    set_color normal
    echo "Have a nice day :)"
    echo
end
