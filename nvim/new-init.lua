require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
        icons = {
            webdev_colors = false,
            glyphs = {
                default = ">",
                symlink = "%",
                bookmark = "#",
                modified = "●",
                folder = {
                    arrow_closed = "v",
                    arrow_open = ">",
                    default = ">",
                    open = ">",
                    empty = "c",
                    empty_open = ">",
                    symlink = "v",
                    symlink_open = ">",
                },
            },
        },
    },
    filters = {
        dotfiles = true,
    },
})

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
-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        -- Required for spellcheck, some LaTex highlights and
        -- code block highlights that do not have ts grammar
        additional_vim_regex_highlighting = {'org'},
    },
    ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
    org_agenda_files = {'~/Documents/Private/**/*'},
    org_default_notes_file = '/Users/justusperlwitz/Documents/Private/00-09 System/04 Org',
})

require("nvim-surround").setup()
