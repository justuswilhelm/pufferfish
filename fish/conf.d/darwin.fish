if is_darwin
    # Macports
    fish_add_path --global /opt/local/bin

    # Timewarrior
    set -x TIMEWARRIORDB "$HOME/.config/timewarrior"
end
