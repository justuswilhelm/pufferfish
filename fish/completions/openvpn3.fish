# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://fishshell.com/docs/current/completions.html
set -l commands (openvpn3 shell-completion --list-commands | string split ' ') shell-completion

complete -c openvpn3 -f -n "not __fish_seen_subcommand_from $commands" -a "$commands"

for cmd in $commands
    set options (openvpn3 shell-completion --list-options $cmd | string split -n ' ')
    for option in $options
        set -l arghelper "(openvpn3 shell-completion --list-options $cmd --arg-helper $option)"
        set -l opt
        if string match -q -ra -- "--.+" $option
            set opt -l (string sub -s 3 -- $option)
        else
            set opt -s (string sub -s 2 -- $option)
        end
        complete -c openvpn3 -n "__fish_seen_subcommand_from $cmd" $opt -a $arghelper
    end
end
