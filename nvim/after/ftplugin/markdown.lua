-- Paste clipboard contents with code fence
vim.keymap.set(
    "n",
    "<leader>p",
    -- 1. Write code fence.
    -- 2. Mark.
    -- 3. Write closing code fence.
    -- 4. Paste
    -- 5. Jump to Mark
    "o```<esc>mao```<esc>kp`a"
)

-- Don't conceal
vim.g.markdown_syntax_conceal = 0
