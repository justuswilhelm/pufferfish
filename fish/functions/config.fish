function config
    pushd
    cd ~/.dotfiles
    script/bootstrap
    set bootstrap_status $status
    popd
    return $bootstrap_status
end
