-- SPDX-FileCopyrightText: 2015-2025 Justus Perlwitz
--
-- SPDX-License-Identifier: GPL-3.0-or-later
-- This is where I put Rust specific config
vim.keymap
    .set("n", "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
         function() vim.cmd.RustLsp({'hover', 'actions'}) end,
         {silent = true, buffer = true})
