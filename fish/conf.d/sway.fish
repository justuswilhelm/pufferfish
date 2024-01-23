# We always want to enable wayland in moz, since we start sway through the terminal
set -x MOZ_ENABLE_WAYLAND 1

# If running from tty1 start sway
set TTY1 (tty)

if test "$TTY1" = /dev/tty1
    exec sway
end
