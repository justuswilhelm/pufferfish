function orgmode-new
    if ! set parent (fd --type d | fzf)
        echo "Must give parent"
        return 1
    end

    echo "Creating new note in $parent"
    if ! read -P "name of note: " note_name
        echo "Must give name"
        return 1
    end

    set date (date -Idate)
    set note_name_escaped (echo "$note_name" | tr "A-Z " "a-z-")

    set new_note $parent$date"_"$note_name_escaped.org
    touch $new_note
    nvim $new_note
end
