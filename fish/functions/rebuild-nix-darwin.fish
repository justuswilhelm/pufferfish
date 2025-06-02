function rebuild-nix-darwin
    alacritty msg create-window \
        -e $SHELL \
        -c "
            screen -h 10000 sh -c '
                sudo darwin-rebuild switch --flake $DOTFILES
                read -p \"press enter to quit\"
            '
        "
end
