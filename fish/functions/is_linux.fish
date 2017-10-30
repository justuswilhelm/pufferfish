function is_linux -d "Return 0 if system is linux"
    uname | grep -v -e 'Darwin' >/dev/null
end
