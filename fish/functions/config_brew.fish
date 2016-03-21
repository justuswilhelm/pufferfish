function config_brew
  if not type brew > /dev/null ^&1
    brew tap "homebrew/bundle"
    brew bundle --global
    brew cleanup
    brew cask cleanup
  end
end
