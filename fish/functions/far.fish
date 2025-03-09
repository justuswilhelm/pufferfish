function far -d "Replace all occurences of a word with another recursively in a given folder" -a location search with
    if [ -z $location ]
        read -S -P "where: " location || begin
            echo "Must enter location"
            return 1
        end
    end

    if [ -z $search ]
        set search_file (mktemp)
        echo "Replace with search regex" >$search_file
        command $EDITOR $search_file
        set search (cat $search_file)
    end

    set files (
        grep --recursive $location --regexp $search --files-with-matches
    ) || begin
        echo "Couldn't find matches in '$location' for '$search'"
        return 1
    end

    echo "Found matches for '$search' in these files:"
    echo $files

    if [ -z $with ]
        set with_file (mktemp)
        echo $search >$with_file
        command $EDITOR $with_file
        set with (cat $with_file)
    end

    set script "/$search/{
    h
    s//$with/g
    H
    x
    s/\n/ >>> /
    w /dev/stdout
    x
    }"

    echo "Script is
$script"

    for file in $files
        echo "Replacing '$search' with '$with' in '$file'"
        if ! sed --in-place $script $file
            echo "Couldn't search '$search' with '$with' in '$file'"
            return 1
        end
    end
end
