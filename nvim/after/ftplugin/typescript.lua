-- SPDX-FileCopyrightText: 2015-2025 Justus Perlwitz
--
-- SPDX-License-Identifier: GPL-3.0-or-later

vim.keymap.set("n", "<localleader>f", ":silent ! npm run format<cr>",
               {buffer = true})
