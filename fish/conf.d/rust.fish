if is_linux
    # Rust
    set -x RUSTUP_HOME "$HOME/.local/rustup"
    set -x CARGO_HOME "$HOME/.local/cargo"
    fish_add_path --global "$HOME/.local/cargo/bin"
end
