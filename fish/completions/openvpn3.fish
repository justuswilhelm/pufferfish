# https://fishshell.com/docs/current/completions.html
set -l commands (openvpn3 shell-completion --list-commands)
complete -c openvpn3 -f
complete -c openvpn3 -s h -l help -d "This help screen"

complete -c openvpn3 -n "not __fish_seen_subcommand_from $commands" -a "$commands"

complete -c openvpn3 -n "__fish_seen_subcommand_from $commands" -a "(openvpn3 shell-completion --list-options shell-completion)"
