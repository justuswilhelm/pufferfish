" Vim Config
  set nocompatible
  filetype off

" Let's set up Vundle
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  Plugin 'gmarik/Vundle.vim'
  " UI Addons
    Plugin 'flazz/vim-colorschemes'
    Plugin 'bling/vim-airline'
    Plugin 'scrooloose/nerdtree'
    Plugin 'kien/ctrlp.vim'
    Plugin 'tpope/vim-fugitive'
    Plugin 'Lokaltog/vim-easymotion'

  " Syntax
    Plugin 'hynek/vim-python-pep8-indent'
    Plugin 'elzr/vim-json'
    Plugin 'editorconfig/editorconfig-vim'
    Plugin 'tpope/vim-markdown'
    Plugin 'kchmck/vim-coffee-script'
    Plugin 'lepture/vim-jinja'
    Plugin 'elixir-lang/vim-elixir'

  " Syntax Magic
    Plugin 'scrooloose/syntastic'
    Plugin 'tpope/vim-surround'

  call vundle#end()

" Syntastic Config
  let g:syntastic_error_symbol = 'x'
  let g:syntastic_warning_symbol = '!'
  let g:syntastic_check_on_open=1
  let g:syntastic_enable_signs=1
  let g:syntastic_javascript_checkers = ['jsl', 'jshint']
  let g:syntastic_python_checkers = ['python', 'flake8', 'pep257']
  let g:syntastic_python_python_exec = 'python3'
  let g:syntastic_tex_checkers = ['chktex']
  let g:syntastic_c_checkers = ['gcc']
  let g:syntastic_elixir_checkers = ['elixir']
  let g:syntastic_enable_perl_checker = 1

" VIM-JSON
  let g:vim_json_syntax_conceal = 0

" VIM-AIRLINE
  let g:airline_powerline_fonts = 0

" Color Stuff
  syntax on
  set background=light
  let g:solarized_termcolors=256
  colorscheme solarized
  hi Normal ctermbg=none

" Change edit appearance
  set encoding=utf-8
  set fileencoding=utf-8
  set cursorline
  set nu
  set autoread
  set more
  set colorcolumn=80
  set tw=80

" Airline
  set laststatus=2
  set ttimeoutlen=50

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
  let mapleader = ','
  " Better ESC
  :imap jk <Esc>

" Set up wildcards
  set wildmenu
  set wildignore+=*/env/*,*.DS_Store

" Change console
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

" Customize Backup Dir location
  set backupdir=~/.vim/backup//
  set directory=~/.vim/swap//
