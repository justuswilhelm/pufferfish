" Bundler
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'

" Little Helpers
Bundle "Townk/vim-autoclose"
Bundle 'tpope/vim-surround'
Bundle 'sjl/vitality.vim'
Bundle 'tpope/vim-rails.git'
Bundle 'vim-scripts/DetectIndent'

" UI Addons
Bundle 'flazz/vim-colorschemes'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'jeetsukumaran/vim-buffergator'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'

" Syntax
Bundle 'sophacles/vim-processing'
Bundle "sudar/vim-arduino-syntax"
Bundle 'tclem/vim-arduino'
Bundle "tikhomirov/vim-glsl.git"
Bundle "jcf/vim-latex"
Bundle "xuhdev/vim-latex-live-preview"
Bundle "sirtaj/vim-openscad"
Bundle "adimit/prolog.vim"
Bundle "tpope/vim-afterimage"

" Vim Latex customization
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'pdflatex  -interaction=batchmode $*'
let g:Tex_ViewRule_pdf = 'Skim'
" Dont require user to press enter (ridiculous!)
map <leader>ll :silent call Tex_RunLaTeX()<cr>

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
let g:solarized_termcolors=256
colorscheme solarized

" Latex Preview
let g:livepreview_previewer = 'open -a Preview'

" Change edit appearance
set encoding=utf-8
set fileencoding=utf-8
set cursorline
set nu
set relativenumber
set autoread
set more
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
" Python specific
au BufRead,BufNewFile *.py set shiftwidth=4 | set tabstop=4 | set softtabstop=4
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

" Save pinky pain for command
nore ; :
nore , ;

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
