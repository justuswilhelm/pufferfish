if is_linux
    # for ssh-agent
    # Need XDG_RUNTIME_DIR, which is not present over SSH
    if [ -n "$XDG_RUNTIME_DIR" ]
        set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
        if [ ! -e "$SSH_AUTH_SOCK" ]
            echo "Could not find $SSH_AUTH_SOCK" >&2
        end
    end
end
