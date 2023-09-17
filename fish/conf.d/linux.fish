if is_linux
    # GNU coreutils
    set -x TIMEOUT_CMD timeout

    # for ssh-agent
    set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    if test ! -e "$SSH_AUTH_SOCK"
        echo "Could not find $SSH_AUTH_SOCK"
    end
end
