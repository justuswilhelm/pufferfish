function config_darwin
    if not uname | grep Darwin >/dev/null
        return
    end
    # disable mouse scaling
    defaults write .GlobalPreferences com.apple.mouse.scaling -1
end
