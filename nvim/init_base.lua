-- General editor settings
-- =======================
-- Shell
-- -----
-- Use sh (this is used for ! commands)
vim.opt.shell = "sh"
-- Autoreload
-- ----------
vim.opt.autoread = true
-- Backup location
-- ---------------
vim.opt.backupdir = vim.fn.expand("~/.config/nvim/backup")
-- Clipboard
-- ---------
-- Use system clipboard
vim.opt.clipboard:append({"unnamedplus"})
-- Undo
-- ----
-- A lot!
vim.opt.history = 1000
vim.opt.undolevels = 1000

-- EditorConfig
-- ============
-- Now default feature in neovim
-- https://neovim.io/doc/user/editorconfig.html
vim.g.editorconfig = true

-- Visual
-- ======
-- Color scheme
-- ------------
if vim.fn.has("termguicolors") then
    vim.opt.termguicolors = true
end
vim.cmd.colorscheme("selenized")
vim.opt.background = "light"
-- Make active pane visible
-- ------------------------
-- https://superuser.com/questions/385553/making-the-active-window-in-vim-more-obvious
-- Translated to lua
-- See: https://neovim.io/doc/user/lua-guide.html#lua-guide-autocommands
local BgHighlight = vim.api.nvim_create_augroup('BgHighlight', { clear = true })
-- XXX Seems to be buggy when called :GRemove or otherwise messing
-- around with file creation / deletion
vim.api.nvim_create_autocmd({ 'WinEnter' }, {
    pattern = '*',
    group = BgHighlight,
    command = 'set cul',
})
vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    pattern = '*',
    group = BgHighlight,
    command = 'set nocul',
})
-- Show commands while they're being typed
vim.opt.showcmd = true
-- Show unprintable characters
vim.opt.list = true
vim.opt.listchars = {
    tab = '»·',
    nbsp = '෴',
    trail = '※',
}
vim.opt.colorcolumn = "80"
-- Match highlighting
-- ------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hlsearch = true
-- Line numbers
-- ------------
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
-- -----------
-- Indent tab with four spaces
vim.opt.shiftwidth = 4

-- Syntax settings
-- ===========================================
-- Enable syntax, if not done by an ftplugin for us
vim.cmd.syntax("enable")
-- This contains: indentation, folding and concealing
-- Syntax
-- ------
vim.cmd.filetype("plugin", "indent", "on")
vim.opt.expandtab = true
-- Concealing
-- ----------
vim.opt.conceallevel = 0
-- Tex
-- Has to be one of the most annoying things ever
vim.g.tex_conceal = ""
-- Format options
-- --------------
-- Stop vim from inserting a newline at inopportune moments
vim.opt.formatoptions:remove({"t"})

-- Keyboard shortcuts
-- =================
-- (not plugin-specific, just neovim builtins)
-- From the lua-guide
-- By default, all mappings are nonrecursive (i.e., vim.keymap.set() behaves
-- like :noremap).
-- Map leader
-- ----------
vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- Yank till end
-- -------------
vim.keymap.set('n', 'Y', 'y$')
-- Pinky pain
-- ----------
vim.keymap.set('n', ';', ':')
-- Run default macro
-- -----------------
vim.keymap.set("n", "<Space>", "@q")
-- Disable highlighting
-- --------------------
vim.keymap.set("n", "<leader><space>", vim.cmd.nohlsearch)

-- Reload configuration
-- --------------------
vim.keymap.set(
    "n",
    "<leader>l",
    function()
        vim.cmd.source(nvim_init_file)
    end
)

-- Make matching a little bit more magical
-- http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
vim.keymap.set("n", "/", "/\\v")
vim.keymap.set("v", "/", "/\\v")
vim.keymap.set("c", "%s/", "%smagic/")
vim.keymap.set("c", "\\>s/", "\\>smagic/")

-- Young Padawan Mode
-- ------------------
vim.keymap.set("i", "jk", "<esc>")

-- TODO timestamp
-- --------------
vim.keymap.set(
    "n",
    "<leader>ts",
    function()
        -- Remove newline at end
        date = string.format(
            " Justus %s",
            string.sub(vim.fn.system({"date", "-Idate"}), 0, -2)
        )
        vim.api.nvim_put({date}, "", true, true)
    end
)

-- Copy current buffer's path
-- --------------------------
-- bufferpath -> bp
vim.keymap.set("n", "<leader>bp", ':let @+ = expand("%")<CR>')

-- Do math on highlighted text
-- ---------------------------
vim.keymap.set("v", "<leader>m", '"ms<C-R>=<C-R>m<CR><ESC>')

-- Jump to next error in quickfix list
-- -----------------------------------
vim.keymap.set("n", "<leader>cne", ':cnext<CR>')

-- Mouse
-- =====
vim.opt.mouse = "a"
