#!/usr/bin/env fish
if [ -n "$argv[1]" ]
    set location "$argv[1]"
else
    read -S -P "where: " location || exit 1
end

if [ -n "$argv[2]" ]
    set replace "$argv[2]"
else
    read -P "replace: " replace || exit 1
end


if [ -n "$argv[3]" ]
    set with "$argv[3]"
else
    read -P "with: " with || exit 1
end

if ! set files (grep --recursive "$location" --regexp "$replace" --files-with-matches)
    echo "Couldn't find matches in '$location' for '$replace'"
    exit 1
end

echo "Found matches for '$replace' in these files:"
echo $files

set script "/$replace/{
h
s//$with/g
H
x
s/\n/ >>> /
w /dev/stdout
x
}"

echo "Script is"
echo "$script"

for file in $files
    echo "Replacing '$replace' with '$with' in '$file'"
    if ! sed --in-place "$script" "$file"
        echo "Couldn't replace '$replace' with '$with' in '$file'"
        exit 1
    end
end
