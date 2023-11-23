begin
    set -l autojump_source /opt/local/share/autojump/autojump.fish
    if [ -f "$autojump_source" ]
        source "$autojump_source"
    end
end
