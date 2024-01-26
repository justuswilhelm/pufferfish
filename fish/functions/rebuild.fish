function rebuild
    if is_linux then
        home-manager switch --flake $DOTFILES/home-manager
    else
        darwin-rebuild switch --flake $DOTFILES/nixpkgs
    end
end
