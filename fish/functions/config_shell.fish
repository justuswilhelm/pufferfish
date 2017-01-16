function config_shell
    if is_linux
        echo "config_shell does not support Linux right now."
        exit 0
    end
    set FISH_PATH (which fish)
    if not finger $USER | grep $FISH_PATH >/dev/null
        sudo chsh -s $FISH_PATH
    end
end
