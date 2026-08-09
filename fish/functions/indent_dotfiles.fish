# SPDX-FileCopyrightText: 2014-2026 Justus Perlwitz
# SPDX-License-Identifier: GPL-3.0-or-later

function indent_dotfiles -d "Format files in '$DOTFILES' dotfiles directory"
    $DOTFILES/bin/format-files.sh
end
