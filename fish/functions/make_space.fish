function make_space
	rm -r "$HOME"/Library/Caches/*
    rm -r "$HOME"/.glide/cache/*
    rm -r "$HOME"/.hex/packages/*
    rm -r "$HOME/Library/Application Support/Skype"/*/media_messaging/emo_cache_v2/
    rm -r "$HOME/Library/Application Support/Slack"/Cache/*
    rm -r "$HOME/Application Support"/Dash/Temp/*
    rm -r "$HOME/Library/Developer/Xcode/DerivedData/"
    rm -r "$HOME/Library/Developer/Xcode/iOS DeviceSupport/"
    echo "This will ask you for your root password"
	sudo rm -r "/Applications/Xcode.app/Contents/Developer/Platforms/"{Watch,AppleTV}*
end
