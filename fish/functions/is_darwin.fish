function is_darwin -d "Return 0 if system is macOS"
    uname | grep -e Darwin >/dev/null
end
