function rebuild
    if is_linux then
        home-manager switch --flake $DOTFILES/nix/generic
    else
        alacritty msg create-window -e $SHELL -c "darwin-rebuild switch --flake $DOTFILES/nix/generic | less"
    end
end
