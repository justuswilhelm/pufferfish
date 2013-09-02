" Bundler
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-rails.git'
Bundle 'kien/ctrlp.vim'
Bundle 'sophacles/vim-processing'
Bundle 'sjl/vitality.vim'
Bundle 'flazz/vim-colorschemes'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'jeetsukumaran/vim-buffergator'
Bundle 'tpope/vim-surround'

" Color Stuff
syntax on
set background=light
let g:solarized_termcolors=256
colorscheme solarized

" Change edit appearance
set cursorline
set nu
set autoread
set more
set hidden

" Change console
set wildmenu

" Plugin specific
filetype plugin indent on
filetype plugin on

" Processing
let g:use_processing_java=1
let processing_doc_path="file:///Applications/Processing.app/Contents/Resources/Java/modes/java/reference/"

" Nerdtree
map <C-n> :NERDTreeToggle<CR>
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let g:NERDTreeDirArrows=0

" cd into current dir
set autochdir

" Indentation
set shiftwidth=2
set tabstop=2
set autoindent smartindent
set smarttab

" Matching
set ignorecase
set smartcase
set incsearch

" Save pinky pain for command
nore ; :
nore , ;

" Don't need no backups
set nobackup
set noswapfile
