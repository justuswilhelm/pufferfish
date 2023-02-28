require("other-nvim").setup({
    mappings = {
        {
            pattern = "/src/lib/figma/(.*).svelte$",
            target = "/src/stories/figma/%1.stories.ts",
            context = "story",
        }
    },
    style = {
        -- How the plugin paints its window borders
        -- Allowed values are none, single, double, rounded, solid and shadow
        border = "solid",

        -- Column seperator for the window
        seperator = "|",

        -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
        width = 0.7,

        -- min height in rows.
        -- when more columns are needed this value is extended automatically
        minHeight = 2
    },
})

vim.api.nvim_set_keymap("n", "<leader>oo", "<cmd>:Other<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>os", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ov", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>oc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })
