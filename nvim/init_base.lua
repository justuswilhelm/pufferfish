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
vim.opt.backupdir = "~/.config/nvim/backup"
-- Clipboard
-- ---------
-- Use system clipboard
vim.opt.clipboard:append({"unnamedplus"})
-- Undo
-- ----
-- A lot!
vim.opt.history = 1000
vim.opt.undolevels = 1000

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
    tab = '»\\ ',
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

-- Syntax settings
-- ===========================================
-- Enable syntax, if not done by an ftplugin for us
vim.cmd.syntax("enable")
-- This contains: indentation, folding and concealing
-- Syntax
-- ------
vim.cmd.filetype("plugin", "indent", "on")
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
-- Folding
-- -------
-- Use treesitter to do our folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr"
vim.opt.foldlevel = 1
-- TODO maybe vim.opt.foldenable?
vim.opt.foldenable = true
-- Concealing
-- ----------
vim.opt.conceallevel = 0
-- Tex
-- Has to be one of the most annoying things ever
vim.g.tex_conceal = ""
-- Json
vim.g.vim_json_syntax_conceal = 0
-- Markdown
vim.g.markdown_syntax_conceal = 0
-- Format options
-- --------------
-- Stop vim from inserting a newline at inopportune moments
vim.opt.formatoptions:remove({"t"})


-- Keyboard shortcuts
-- =================
-- (not plugin-specific, just neovim builtins)
vim.cmd([[
let mapleader = ','
let maplocalleader = ','
" Yank till end
" -------------
nnoremap Y y$
" Smarter text navigation
" -----------------------
nnoremap j gj
nnoremap k gk
" Pinky pain
" ----------
nore ; :
" Run default macro
" -----------------
nnoremap <Space> @q
" Disable highlighting
" --------------------
nnoremap <leader><space> :noh<cr>

" Reload configuration
" --------------------
nnoremap <leader>l :source ~/.config/nvim/init.lua<cr>

" Make matching a little bit more magical
" http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %s/\v
cnoremap \>s/ \>s/\v

" Young Padawan Mode
" ------------------
inoremap jk <esc>

" TODO timestamp
" --------------
nmap <leader>ts A Justusjk:r!date "+\%Y-\%m-\%d"<CR>kJ$
]])

-- Mouse
-- =====
vim.opt.mouse = "a"

-- Files and folders to ignore
-- ===========================
-- TODO is this still relevant? I mean... we have gitignore, right?
vim.cmd([[
set wildignore=*/.git/*
set wildignore+=*/.DS_Store
set wildignore+=*/vendor
set wildignore+=*/env/*
set wildignore+=*.pyc
set wildignore+=*/__pycache__/
set wildignore+=*/deps/* " Elixir deps
set wildignore+=*/_build/* " Elixir builds
set wildignore+=*/Pods/* " CocoaPods
set wildignore+=*/node_modules/*
set wildignore+=*/bower_components/*
set wildignore+=*/elm-stuff/*
set wildignore+=*/staticfiles/*
set wildignore+=*.gch
set wildignore+=*.o
]])
