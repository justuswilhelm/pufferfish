set -x ASDF_DATA_DIR "$HOME/.local/share/asdf"

if is_darwin
    # With nix, no need to do anything
else if is_linux
    set -x ASDF_DIR $HOME/.local/asdf
    source "$HOME/.local/asdf/asdf.fish"
else
    echo "Asdf not installed"
end
