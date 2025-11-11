# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function fish_prompt -d "Show prompt"
    set last_status $status

    set_color yellow
    prompt_pwd | tr -d '\n'
    set_color normal
    git_status

    if [ $last_status -gt 0 ]
        set_color red
        echo -n $last_status
        set_color normal
    end
    echo '$'
end
