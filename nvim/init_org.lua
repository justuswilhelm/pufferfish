-- Org mode configuration
-- ======================
nvim_init_file = vim.fn.expand("~/.config/nvim/init_org.lua")
vim.cmd.source("~/.config/nvim/init_base.lua")

-- Plugin Specific Settings
-- ========================
-- Load plugins
-- ------------
local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.config/nvim/plugged")
Plug("nvim-treesitter/nvim-treesitter")
Plug("kylechui/nvim-surround")
Plug("nvim-orgmode/orgmode")
Plug("ibhagwan/fzf-lua", {branch= "main"})
vim.call('plug#end')

-- fzf-lua
-- =======
require("fzf-lua").setup()
vim.keymap.set("n", "<c-P>", require('fzf-lua').files, { silent=true })

-- Orgmode
-- =======
-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop,
  -- highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
  -- org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  -- org_default_notes_file = '~/Dropbox/org/refile.org',
})
