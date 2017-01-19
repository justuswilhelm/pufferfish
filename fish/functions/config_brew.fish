function config_brew
    set -l LINUX_GREP_FLAGS -v -e 'cask' -e 'clang-format' -e 'elm-format' -e 'macos'

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
    else if is_linux
        brew bundle --file=(grep $LINUX_GREP_FLAGS $HOME/.Brewfile | psub) --verbose
    else
        brew bundle --global
    end

    brew cleanup -s
    if not is_linux
        brew cask cleanup
    end
end
