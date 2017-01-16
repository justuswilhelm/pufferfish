function config_symlinks
    echo $XDG_CONFIG_HOME
    mkdir -pv $XDG_CONFIG_HOME
    rm -rf "$XDG_CONFIG_HOME/fish"
    for path in "fish" "nvim"
        ln -sfv "$DOTFILES/$path" $XDG_CONFIG_HOME
    end
    for path in "latexmkrc" "Brewfile" "tmux.conf" "isort.cfg" "emacs"
        ln -sfv "$DOTFILES/misc/$path" "$HOME/.$path"
    end
    for path in "httpie" "mitmproxy"
        ln -sfv "$DOTFILES/$path" "$HOME/.$path"
    end
    ln -sfv "$DOTFILES/bin" "$HOME"
end
