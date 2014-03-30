" Bundler
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'

" Little Helpers
Bundle 'tpope/vim-surround'
Bundle 'sjl/vitality.vim'

" UI Addons
Bundle 'flazz/vim-colorschemes'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'

" Syntax
Bundle "tikhomirov/vim-glsl.git"

" Syntax Magic
Bundle 'scrooloose/syntastic'

let g:syntastic_error_symbol = 'x'
let g:syntastic_warning_symbol = '!'
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers = ['jsl', 'jshint']

" Color Stuff
syntax on
set background=light
colorscheme solarized

" Change edit appearance
set encoding=utf-8
set fileencoding=utf-8
set cursorline
set nu
set autoread
set more
set colorcolumn=85
set tw=80
nnoremap <up> :setlocal spell! spelllang=en_us<CR>

" Airline
set laststatus=2
set ttimeoutlen=50

" Change command line behavior
set cmdheight=2

" Some keys
set pastetoggle=<F2>
set clipboard=unnamed
nmap <C-v> gg"*yG

" Text Navigation
nnoremap j gj
nnoremap k gk

" Undo Levels
set history=1000
set undolevels=1000

" Highlight them Whitespaces
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

" Change edit behavior
let mapleader = ","
" Better ESC
:imap jk <Esc>

" Change console
set wildmenu
set showcmd

" Plugin specific
filetype plugin indent on
filetype plugin on

" Nerdtree
map <C-n> :NERDTreeToggle<CR>
" Open Nerdtree on start
let g:NERDTreeDirArrows=0

" cd into current dir
set autochdir

"" Indentation
  " Python specific
  au BufRead,BufNewFile *.py set shiftwidth=4 | set tabstop=4 | set softtabstop=4 | set number
  " The rest
  set shiftwidth=2
  set tabstop=2
  set autoindent
  set smartindent
  set expandtab
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

" Better Macros
:nnoremap <Space> @q

" Save pinky pain for command
nore ; :
nore , ;

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
