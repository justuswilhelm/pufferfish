if is_darwin
    set -x ASDF_DIR /opt/local/share/asdf
    # Macport install path
    source /opt/local/share/asdf/asdf.fish
end

set -x ASDF_DATA_DIR ~/.local/share/asdf
