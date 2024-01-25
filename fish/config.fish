# Theme
# =====
# TODO make this selenized
fish_config theme choose "Solarized Light"

source /nix/var/nix/profiles/default/etc/profile.d/nix.fish

if is_linux
    # for ssh-agent
    # Need XDG_RUNTIME_DIR, which is not present over SSH
    if [ -n "$XDG_RUNTIME_DIR" ]
        set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
        if [ ! -e "$SSH_AUTH_SOCK" ]
            echo "Could not find $SSH_AUTH_SOCK" >&2
        end
    end

    # We always want to enable wayland in moz, since we start sway through the terminal
    set -x MOZ_ENABLE_WAYLAND 1

    # If running from tty1 start sway
    set TTY1 (tty)

    if test "$TTY1" = /dev/tty1
        exec sway
    end
end
