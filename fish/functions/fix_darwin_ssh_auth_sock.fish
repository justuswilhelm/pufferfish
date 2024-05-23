# Fix SSH_AUTH_SOCK on darwin
# HACKY
# Launchctl print docs say to not rely on the output
function fix_darwin_ssh_auth_sock
    echo "SSH_AUTH_SOCK is $SSH_AUTH_SOCK"
    set uid (id -u "$USER")
    set target "gui/$uid/com.openssh.ssh-agent"
    if not set path (
        launchctl print "$target" |
            grep --max-count 1 --only-matching --regexp "/private/.*/Listeners"
    )
        echo "Could not get path for SSH_AUTH_SOCK"
        return 1
    end
    echo "Sock path for target $target is $path"
    if [ "$path" = "$SSH_AUTH_SOCK" ]
        set_color green
        echo "SSH_AUTH_SOCK is already set to correct path"
        echo "No further action is required"
        set_color normal
        return 0
    end
    set --export SSH_AUTH_SOCK "$path"
    if ssh-add -l
        echo "ssh-add -l ran successfully"
        return 0
    else
        echo "ssh-add -l did not run successfully"
    end
end
