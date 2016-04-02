" Vim-Plug
  call plug#begin('~/.config/nvim/plugged')
    " File handling
    Plug 'kien/ctrlp.vim'

    " Syntax plugings
    Plug 'dag/vim-fish'
    Plug 'rizzatti/dash.vim'

    " Syntax checking
    Plug 'scrooloose/syntastic'

    " Show indentations
    Plug 'Yggdroot/indentLine'

    " Color scheme
    Plug 'altercation/vim-colors-solarized'

    " Text mangling
    Plug 'tpope/vim-surround'
    Plug 'fisadev/vim-isort'
    Plug 'easymotion/vim-easymotion'

    " Better text navigation
    Plug 'jeffkreeftmeijer/vim-numbertoggle'
    Plug 'christoomey/vim-tmux-navigator'

  call plug#end()

" Keyboard shortcuts
  let mapleader = ','
  " Normal Mode
    " Netrw splits
    nnoremap <C-n> :vs.<CR>
    nnoremap <C-s> :sp.<CR>
    nnoremap <C-l> :e.<CR>
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

" Ignore folders
  set wildignore+=*/.git/*,*/.DS_Store,*/vendor,*/env/

" Netrw
  let g:netrw_altv=1
  let g:netrw_liststyle=3

" Syntastic
  let g:syntastic_html_checkers=[]
  let g:syntastic_python_checkers=['flake8', 'pep257']

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

" Indentation
  " When on, a <Tab> in front of a line inserts blanks according to
  " 'shiftwidth'.
  set smarttab
  " Copy indent from current line when starting a new line
  set autoindent
  " Do smart autoindenting when starting a new line.
  set smartindent
  " In Insert mode: Use the appropriate number of spaces to insert a <Tab>
  set expandtab
  " Number of spaces that a <Tab> in the file counts for.
  set tabstop=2
  " Returns the effective value of 'shiftwidth'. This is the
  " 'shiftwidth' value unless it is zero, in which case it is the
  " 'tabstop' value.
  set shiftwidth=0

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
