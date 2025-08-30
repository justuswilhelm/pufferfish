-- Paste clipboard contents with code fence
vim.keymap.set(
    "n",
    "<leader>cfp",
    -- 1. Write code fence. Mark.
    -- 2. Paste
    -- 3. Write closing code fence. Jump to mark.
    "o```<esc>magpo```<esc>`a"
)

-- Don't conceal
vim.g.markdown_syntax_conceal = 0
