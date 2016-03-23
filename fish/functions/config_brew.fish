function config_brew
    if not type brew > /dev/null ^& 1
        echo "Install brew"
        return 1
    end
    brew tap "homebrew/bundle"
    brew bundle --global
    brew cleanup
    brew cask cleanup
end
