-- SPDX-FileCopyrightText: 2026 Justus Perlwitz
-- SPDX-License-Identifier: GPL-3.0-or-later
-- Wrap marked text with {% blocktrans %}
vim.keymap.set("v", "<leader>bt",
               "dO{% blocktrans %}<esc>po{% endblocktrans %}<esc>", {
    buffer = true,
    desc = "Wrap selected text with {% blocktrans %}"
})
-- <hello>asd 'asd' asd</hello>
-- Wrap marked text with {% trans '' %}
vim.keymap.set("v", "<leader>t", "di{% trans '<esc>pa' %}<esc>", {
    buffer = true,
    desc = "Wrap selected text with {% blocktrans %}"
})
-- Run bin/format.sh. Useful for some of my projects.
vim.keymap.set("n", "<localleader>f", ":silent ! bin/format.sh<cr>",
               {buffer = true})
