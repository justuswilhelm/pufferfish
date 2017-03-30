function clear_cache
    rm -r "$HOME"/Library/Caches/*
    rm -r "$HOME"/.glide/cache/*
    rm -r "$HOME"/.hex/packages/*
    rm -r "$HOME/Library/Application Support/Skype"/*/media_messaging/emo_cache_v2/
    rm -r "$HOME/Library/Application Support/Slack"/Cache/*
    rm -r "$HOME/Application Support"/Dash/Temp/*
    rm -rf "$HOME"/Library/Developer/Xcode/DerivedData/ModuleCache/*
end
