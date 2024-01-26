function rebuild
    if is_linux then
        home-manager switch --flake $DOTFILES/nix/generic
    else
        darwin-rebuild switch --flake $DOTFILES/nix/generic
    end
end
