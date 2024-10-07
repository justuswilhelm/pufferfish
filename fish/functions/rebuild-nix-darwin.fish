function rebuild-nix-darwin
    alacritty msg create-window \
        -e $SHELL \
        -c "
            screen -h 10000 sh -c '
                darwin-rebuild switch --flake $DOTFILES/nix/generic
                read -p \"press enter to quit\"
            '
        "
end
