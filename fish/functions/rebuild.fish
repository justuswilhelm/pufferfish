function rebuild
    if is_linux then
        home-manager switch --flake $DOTFILES/nix/debian
    else
        darwin-rebuild switch --flake $DOTFILES/nix/darwin
    end
end
