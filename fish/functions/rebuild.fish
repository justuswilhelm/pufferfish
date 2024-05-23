function rebuild
    if is_linux then
        home-manager switch --flake $DOTFILES/nix/generic
    else
        alacritty msg create-window \
            -e $SHELL -c '
            screen -h 10000 sh -c \
                "darwin-rebuild switch --flake $DOTFILES/nix/generic
            read -p \'press enter to quit\'"
        '
    end
end
