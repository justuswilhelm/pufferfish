" Vim-Plug
" ========
call plug#begin('~/.config/nvim/plugged')
" Language specific
" -----------------
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'guersam/vim-j', {'for': 'j'}
Plug 'leafgarland/typescript-vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
" TODO Still needed? Justus 2023-03-10
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'dag/vim-fish', {'for': 'fish'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'tpope/vim-markdown', {'for': 'markdown'}

" Ascii stuff
" -----------
Plug 'jbyuki/venn.nvim'

" Treesitter
" ----------
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'kylechui/nvim-surround' " Works with treesitter

" nvim-orgmode
" ------------
Plug 'nvim-orgmode/orgmode'

" Improve editor appearance
" -------------------------
Plug 'airblade/vim-gitgutter'

" Improve general editor behavior
" -------------------------------
Plug 'christoomey/vim-tmux-navigator'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'epeli/slimux'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'rgroli/other.nvim'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-fugitive'

" LSP Config
" ----------
Plug 'neovim/nvim-lspconfig'

" Autocomplete
" ------------
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For vsnip
Plug 'hrsh7th/cmp-vsnip'

call plug#end()

" Indentation
" ===========
syntax enable
filetype plugin indent on
set expandtab
set shiftwidth=4
set tabstop=4

" Don't let EditorConfig mess with our configuration
let g:EditorConfig_preserve_formatoptions = 1
set formatoptions-=t

" Keyboard shortcuts
" ==================
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
nnoremap <leader>l :source ~/.config/nvim/init.vim<cr>

" Make matching a little bit more magical
" http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %s/\v
cnoremap \>s/ \>s/\v

" Young Padawan Mode
" ------------------
inoremap jk <esc>

" Nvim-tree
" -----
nnoremap <C-t> :NvimTreeOpen<CR>

" TODO timestamp
" --------------
nmap <leader>ts A Justusjk:r!date "+\%Y-\%m-\%d"<CR>kJ$

" vim-vsnip
" =========
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'

" Files and folders to ignore
" ===========================
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

" Use a different shell
" =====================
if &shell =~# 'fish$'
    set shell=sh
endif

" Slimux
" ======
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
map <Leader>a :SlimuxShellLast<CR>
map <Leader>k :SlimuxSendKeysLast<CR>

" Line numbers
" ============
set number relativenumber

" Use system clipboard
" ====================
set clipboard+=unnamedplus

" Undo Levels
" ===========
set history=1000
set undolevels=1000

" Customize Backup Dir location
" =============================
set backupdir=~/.config/nvim/backup/

" Clang-Format
" ============
let g:clang_format#code_style = "llvm"

" Mouse mode
" ==========
set mouse=a

" Why not zoidberg?
" =================
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" vim-vsnip
" =========
let g:vsnip_snippet_dir = expand('~/.config/nvim/snippets/')

" Svelte
" ======
let g:svelte_preprocessor_tags = [
            \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
            \ ]
let g:svelte_preprocessors = ['ts', 'typescript']

" Autoreload
" ==========
set autoread

" Load Lua config
" ===============
luafile $HOME/.config/nvim/new-init.lua
