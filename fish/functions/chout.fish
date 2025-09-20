# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function chout --description "Touch a file, create base path if needed" -a path
    if [ -e $path ]
        echo "$path already exists"
    end
    set dir (dirname $path)
    if ! mkdir --parents --verbose $dir
        echo "Couldn't mkdir at $dir"
        return 1
    end
    touch $path
end
