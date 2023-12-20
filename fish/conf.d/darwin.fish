if is_darwin
    # Macports
    fish_add_path --global /opt/local/bin

    # Git annex
    # --append is important, otherwise it collides with the system git
    fish_add_path --append --global /Applications/Free/git-annex.app/Contents/MacOS

    # Rust
    set -x RUSTUP_HOME "$HOME/.local/share/rustup"
    set -x CARGO_HOME "$HOME/.local/share/cargo"
    fish_add_path --global "$HOME/.local/share/cargo/bin"

    # Timewarrior
    set -x TIMEWARRIORDB "$HOME/.config/timewarrior"

    # We use timeout from coreutils
    set -x TIMEOUT_CMD gtimeout
end
