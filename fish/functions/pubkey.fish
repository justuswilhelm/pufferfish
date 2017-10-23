function pubkey
    set -l pubkey_location "$HOME/.ssh/id_rsa.pub"
    echo "Copying ssh public key from $pubkey_location"
    pbcopy <$pubkey_location
    or xclip <$pubkey_location
end
