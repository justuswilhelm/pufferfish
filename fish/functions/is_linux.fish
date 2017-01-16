function is_linux
    uname | grep -v -e 'Darwin' >/dev/null
end
