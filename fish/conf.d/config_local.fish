if is_darwin
    # Macports
    fish_add_path --global /opt/local/bin

    # We use timeout from coreutils
    set -x TIMEOUT_CMD gtimeout
end
