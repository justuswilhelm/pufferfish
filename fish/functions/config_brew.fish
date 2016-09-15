function config_brew
    if contains $argv "clean"
        brew bundle cleanup --global --force
    end
    if not type brew >/dev/null ^&1
        echo "Install brew"
        return 1
    end
    brew tap "homebrew/bundle"
    brew update
    brew bundle --global
    brew cleanup
    brew cask cleanup
end
