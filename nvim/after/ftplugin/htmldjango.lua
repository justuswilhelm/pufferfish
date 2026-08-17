-- SPDX-FileCopyrightText: 2026 Justus Perlwitz
-- SPDX-License-Identifier: GPL-3.0-or-later
-- Wrap marked text with {% blocktrans %}
vim.keymap.set("v", "<leader>bt",
               "dO{% blocktrans %}<esc>po{% endblocktrans %}<esc>", {
    buffer = true,
    desc = "Wrap selected text with {% blocktrans %}"
})
