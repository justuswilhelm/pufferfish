function config_brew
    if is_linux
        echo "Only macOS is supported."
        exit 1
    end

    if contains $argv "clean"
        brew bundle cleanup --global --force
    end

    if not type brew >/dev/null ^&1
        echo "Install brew"
        return 1
    end

    brew tap "homebrew/bundle"
    brew update
    brew upgrade

    if set -q CI
        echo "CircleCI: Skipping brew bundle"
    else
        brew bundle --file=(grep $MACOS_GREP_FLAGS $HOME/.Brewfile | psub) --verbose
    end

    brew cleanup -s
    brew cask cleanup
end
