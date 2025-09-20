-- SPDX-FileCopyrightText: 2015-2025 Justus Perlwitz
--
-- SPDX-License-Identifier: GPL-3.0-or-later

-- Paste clipboard contents with code fence
-- 1. Write code fence.
-- 2. Mark.
-- 3. Write closing code fence.
-- 4. Paste
-- 5. Jump to Mark
vim.keymap.set("n", "<leader>p", "o```<esc>mao```<esc>kp`a")

-- xmap ic :<c-u>call search('```')<cr> \| normal! lvi)<cr>
-- select line after ```: https://stackoverflow.com/a/60549604
local function select_inside_fence()
    local prev = vim.fn.search("^`\\{3,}[^`]*$", "bW")
    if prev == 0 then error("Couldn't find beginning of code fence") end
    -- Count how many backticks we have
    -- We can probably combine search and matchbufline, but whatever...
    local match = vim.fn.matchbufline(vim.api.nvim_get_current_buf(),
                                      "^\\(`\\{3,}\\)[^`]*$", prev, prev,
                                      {submatches = true})
    if #match == 0 then error("no matches") end
    if #match > 1 then error("Too many matches") end
    local backticks = match[1]["submatches"][1]
    local next = vim.fn.search("^" .. backticks .. "$", "W")
    if next == 0 then
        error(string.format("Couldn't find end of code fence for %d backticks",
                            #backticks))
    end
    vim.cmd(string.format('normal! %sGVo%sG', prev + 1, next - 1))
end
vim.keymap.set({'x', 'o'}, 'ic', select_inside_fence,
               {silent = true, buffer = true})

-- Don't conceal
vim.g.markdown_syntax_conceal = 0
