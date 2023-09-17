set -x ASDF_DATA_DIR "$HOME/.local/share/asdf"

if is_darwin
    set -x ASDF_DIR /opt/local/share/asdf
    # Macport install path
    source /opt/local/share/asdf/asdf.fish
else if is_linux
    set -x ASDF_DIR $HOME/.local/asdf
    source "$HOME/.local/asdf/asdf.fish"
else
    echo "Asdf not installed"
end
