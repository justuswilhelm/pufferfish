if is_linux
    # for ssh-agent
    set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    if test ! -e "$SSH_AUTH_SOCK"
        echo "Could not find $SSH_AUTH_SOCK"
    end
end
