if is_darwin
    # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1345383219
    fish_add_path --prepend --global "$HOME/.nix-profile/bin" "/etc/profiles/per-user/$USER/bin" "/run/current-system/sw/bin" "/nix/var/nix/profiles/default/bin"

    # Timewarrior
    set -x TIMEWARRIORDB "$HOME/.config/timewarrior"
end
