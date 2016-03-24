function config_symlinks
    echo $XDG_CONFIG_HOME
    mkdir -pv $XDG_CONFIG_HOME
    rm -rf "$XDG_CONFIG_HOME/fish"
    for path in "fish" "nvim"
        ln -sfv "$DOTFILES/$path" $XDG_CONFIG_HOME
    end
    for path in "latexmkrc" "brewfile" "tmux.conf" "isort.cfg"
        ln -fv "$DOTFILES/misc/$path" $HOME/.$path
    end
    ln -sfv "$DOTFILES/bin" "$HOME"
end
