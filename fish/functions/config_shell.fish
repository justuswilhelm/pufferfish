function config_shell
    set FISH_PATH (which fish)
    if not finger $USER | grep $FISH_PATH >/dev/null
        sudo chsh -s $FISH_PATH
    end
end
