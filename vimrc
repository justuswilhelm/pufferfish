" Bundler
  set nocompatible
  filetype off
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()

Bundle 'gmarik/Vundle.vim'

" Little Helpers
  Bundle 'tpope/vim-surround'
  Bundle 'sjl/vitality.vim'

" UI Addons
  Bundle 'flazz/vim-colorschemes'
  Bundle 'bling/vim-airline'
  Bundle 'scrooloose/nerdtree'
  Bundle 'kien/ctrlp.vim'
  Bundle 'tpope/vim-fugitive'
  Bundle 'myusuf3/numbers.vim'
  Bundle 'jmcantrell/vim-virtualenv'

" Syntax
  Bundle 'tikhomirov/vim-glsl.git'
  Bundle 'jnwhiteh/vim-golang.git'
  Bundle 'hynek/vim-python-pep8-indent'
  Bundle 'kovisoft/slimv'
  Bundle 'elzr/vim-json'

" Syntax Magic
  Bundle 'scrooloose/syntastic'

  call vundle#end()

" Syntastic Config
  let g:syntastic_error_symbol = 'x'
  let g:syntastic_warning_symbol = '!'
  let g:syntastic_check_on_open=1
  let g:syntastic_enable_signs=1
  let g:syntastic_javascript_checkers = ['jsl', 'jshint']
  let g:syntastic_tex_checkers = ['chktex']
  let g:syntastic_python_checkers = ['python', 'pep8']
  let g:syntastic_c_checkers = ['gcc']
  let g:syntastic_enable_perl_checker = 1

" SLIMV
  let g:paredit_mode = 0

" VIM-JSON
  let g:vim_json_syntax_conceal = 0

" VIM-AIRLINE
  let g:airline_powerline_fonts = 1

" Color Stuff
  syntax on
  set background=dark
  let g:solarized_termcolors=256
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

" Airline
  set laststatus=2
  set ttimeoutlen=50

" Change command line behavior
  set cmdheight=2

" Some keys
  set pastetoggle=<F2>
  set clipboard=unnamed
" Backspace Shizz
  set backspace=indent,eol,start

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

" Nerdtree
  map <C-n> :NERDTreeToggle<CR>

" cd into current dir
  set autochdir

" Indentation
  filetype on
  filetype plugin on
  filetype indent on
  set autoindent

  set smarttab
  set smartindent
  set expandtab
  set cindent
  set tabstop=2
  set shiftwidth=2

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

" Customize Backup Dir location
  set backupdir=~/.vim/backup//
  set directory=~/.vim/swap//

" MVIM
  set guifont=Monospace:h20

" GOLANG specific
  autocmd FileType go autocmd BufWritePre <buffer> Fmt
