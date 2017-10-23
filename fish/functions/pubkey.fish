function pubkey
    set -l pubkey_location "$HOME/.ssh/id_rsa.pub"
    if which pbcopy > /dev/null
        pbcopy < $pubkey_location
    else
        xclip -selection clipboard < $pubkey_location
    end
    echo "Copied SSH public key from $pubkey_location"
end
