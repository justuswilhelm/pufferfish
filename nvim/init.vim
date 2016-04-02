" Vim-Plug
  call plug#begin('~/.config/nvim/plugged')
    " Language specific
    Plug 'dag/vim-fish', {'for': 'fish'}
    Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
    Plug 'fisadev/vim-isort', {'for': 'python'}
    Plug 'guns/vim-sexp', {'for': 'lisp'}

    " Improve editor appearance
    Plug 'Yggdroot/indentLine'
    Plug 'airblade/vim-gitgutter'
    Plug 'altercation/vim-colors-solarized'
    Plug 'scrooloose/syntastic'

    " Improve general editor behavior
    Plug 'benekastah/neomake'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'easymotion/vim-easymotion'
    Plug 'kien/ctrlp.vim'
    Plug 'rizzatti/dash.vim'
    Plug 'rking/ag.vim'
    Plug 'SirVer/ultisnips'
    Plug 'tpope/vim-surround'

  call plug#end()

" Indentation
syntax enable
filetype plugin indent on
set expandtab
set shiftwidth=4
set tabstop=4

" Keyboard shortcuts
  let mapleader = ','
  let maplocalleader = ','
  " Normal Mode
    " Netrw splits
    nnoremap <c-j> <c-w>j
    nnoremap <c-k> <c-w>k
    nnoremap <c-h> <c-w>h
    nnoremap <c-l> <c-w>l
    " Append to end
    nnoremap L $p
    nnoremap K $pkJ
    " Yank till end
    nnoremap Y y$
    " Smarter text navigation
    nnoremap j gj
    nnoremap k gk
    " Pinky pain
    nore ; :
    " Run default macro
    nnoremap <Space> @q
    " Disable highlighting
    nnoremap <leader><space> :noh<cr>

  " Matching
    nnoremap / /\v
    vnoremap / /\v

  " Young Padawan Mode
    inoremap jk <esc>
    inoremap <esc> <NOP>
    noremap <Up> <NOP>
    noremap <Down> <NOP>
    noremap <Left> <NOP>
    noremap <Right> <NOP>

  " DashSearch (OS X only with Dash)
    nmap <silent> <leader>d <Plug>DashSearch

" Neomake
  autocmd! BufWritePost * Neomake

" Ignore folders
  set wildignore+=*/.git/*,*/.DS_Store,*/vendor,*/env/

" Use a different shell
if &shell =~# 'fish$'
    set shell=sh
endif

" Netrw
  let g:netrw_altv=1
  let g:netrw_liststyle=3

" Syntastic
  let g:syntastic_html_checkers=[]
  let g:syntastic_python_checkers=['pydocstyle']

" Show unprintable characters
  set list
  set listchars=tab:>.,trail:.,extends:#,nbsp:.

" Column length
  set colorcolumn=80
  set tw=80

" Show commands while they're being typed
  set showcmd

" Line numbers
  set nu

" Folds
  set foldmethod=indent
  set foldlevelstart=2
  set foldminlines=2
  let g:tex_conceal = "" "Has to be one of the most annoying things ever

" Use system clipboard
  set clipboard=unnamed

" Undo Levels
  set history=1000
  set undolevels=1000

" Matching
  set ignorecase
  set smartcase
  set gdefault
  set incsearch
  set showmatch
  set hlsearch

" Color Stuff
  set background=dark
  colorscheme solarized
  let g:solarized_termcolors=256
  hi Normal ctermbg=none

" Customize Backup Dir location
  set backupdir=~/.config/nvim/backup/
  set directory=~/.config/nvim/swap/
