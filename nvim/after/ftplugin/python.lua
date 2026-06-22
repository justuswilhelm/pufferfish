-- SPDX-FileCopyrightText: 2015-2025 Justus Perlwitz
--
-- SPDX-License-Identifier: GPL-3.0-or-later
vim.keymap.set("n", "<localleader>f", ":silent ! bin/format.sh<cr>",
               {buffer = true})
-- SPDX-SnippetBegin
-- SPDX-License-Identifier: CC-BY-SA-4.0
-- SPDX-SnippetCopyrightText: 2023 pseudoc
-- https://stackoverflow.com/a/75015253
vim.g.python_indent = {
    disable_parentheses_indenting = false,
    closed_paren_align_last_line = false,
    searchpair_timeout = 150,
    continue = "shiftwidth()",
    open_paren = "shiftwidth()",
    nested_paren = "shiftwidth()"
}
-- SPDX-SnippetEnd
