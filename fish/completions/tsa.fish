# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

complete -c tsa --no-files --arguments "(tmux list-sessions -F '#{session_name}')"
