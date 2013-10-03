" Bundler
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-fugitive'

Bundle 'tpope/vim-rails.git'
Bundle 'kien/ctrlp.vim'
Bundle 'sophacles/vim-processing'
Bundle 'sjl/vitality.vim'
Bundle 'flazz/vim-colorschemes'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'jeetsukumaran/vim-buffergator'
Bundle 'tpope/vim-surround'
Bundle 'tclem/vim-arduino'
Bundle "sudar/vim-arduino-syntax"
Bundle "tikhomirov/vim-glsl.git"
" Color Stuff
syntax on
set background=light
let g:solarized_termcolors=256
colorscheme solarized

" Change edit appearance
set cursorline
set nu
set relativenumber
set autoread
set more
set wrap
set textwidth=79
set colorcolumn=85

" Some keys
set pastetoggle=<F2>

" Text Navigation
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Close Buffers instead of closing vim
:cnoreabbrev wq w<bar>bd
:cnoreabbrev q bd

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Undo Levels
set history=1000
set undolevels=1000

" Highlight them Whitespaces
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

" Not too sure about this
"set hidden

" Change edit behavior
let mapleader = ","
" Better ESC
:imap jk <Esc>

" Better Vimrc editing
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Change console
set wildmenu
set showcmd

" Plugin specific
filetype plugin indent on
filetype plugin on

" Processing
let g:use_processing_java=1
let processing_doc_path="file:///Applications/Processing.app/Contents/Resources/Java/modes/java/reference/"

" Arduino
au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino

" Nerdtree
map <C-n> :NERDTreeToggle<CR>
" Open Nerdtree on start
autocmd vimenter * if !argc() | NERDTree | endif
let g:NERDTreeDirArrows=0

" cd into current dir
set autochdir

" Indentation
set shiftwidth=2
set tabstop=2
set autoindent smartindent
set smarttab
set copyindent

" Matching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" Save pinky pain for command
nore ; :
nore , ;

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
