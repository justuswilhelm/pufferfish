# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function is_darwin -d "Return 0 if system is macOS"
    uname | grep -e Darwin >/dev/null
end
