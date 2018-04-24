" Vim-Plug
  call plug#begin('~/.config/nvim/plugged')
    " Language specific
    Plug 'ElmCast/elm-vim', {'for': 'elm'}
    Plug 'Glench/Vim-Jinja2-Syntax', {'for': 'jinja'}
    Plug 'amperser/proselint'
    Plug 'dag/vim-fish', {'for': 'fish'}
    Plug 'digitaltoad/vim-pug', {'for': 'pug'}
    Plug 'elixir-lang/vim-elixir'
    Plug 'elzr/vim-json', {'for': 'json'}
    Plug 'fatih/vim-go', {'for': 'go'}
    Plug 'fisadev/vim-isort', {'for': 'python'}
    Plug 'godlygeek/tabular'
    Plug 'guersam/vim-j', {'for': 'j'}
    Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
    Plug 'tpope/vim-haml'
    Plug 'tpope/vim-markdown'

    " Improve editor appearance
    Plug 'Yggdroot/indentLine'
    Plug 'airblade/vim-gitgutter'
    Plug 'dracula/vim'

    " Improve general editor behavior
    Plug 'AndrewRadev/linediff.vim'
    Plug 'benekastah/neomake'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'easymotion/vim-easymotion'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'epeli/slimux'
    Plug 'mtth/scratch.vim'
    Plug 'qpkorr/vim-renamer'
    Plug 'rhysd/vim-clang-format'
    Plug 'rizzatti/dash.vim'
    Plug 'rking/ag.vim'
    Plug 'tpope/vim-fugitive'
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
    " Fix TmuxNavigateLeft
    nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
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

    " Reload configuration
    nnoremap <leader>l :source ~/.config/nvim/init.vim<cr>

  " Matching
    nnoremap / /\v
    vnoremap / /\v

  " Young Padawan Mode
    inoremap jk <esc>

  " DashSearch (OS X only with Dash)
    nmap <silent> <leader>d <Plug>DashGlobalSearch

  " Clang-Format
    nmap <silent> <leader>c :ClangFormat<cr>
    vmap <silent> <leader>c :ClangFormat<cr>


  " TODO timestamp
    nmap <leader>ts A Justusjk:r!date "+\%Y-\%m-\%d"<CR>kJ$

" Neomake
  autocmd! BufWritePost * Neomake
  let g:neomake_java_enabled_makers = []
  let g:neomake_python_enabled_makers = ["flake8"]
  let g:neomake_elixir_mix_maker = {
        \ 'exe' : 'mix',
        \ 'args': ['compile', '--warnings-as-errors'],
        \ 'cwd': getcwd(),
        \ 'errorformat':
          \ '** %s %f:%l: %m,' .
          \ '%f:%l: warning: %m'
        \ }
  let g:neomake_elixir_enabled_makers = ['mix']

" Files and folders to ignore
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

" ctrlp.vim
  let g:ctrlp_show_hidden=1
  let g:ctrlp_working_path_mode = ''
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Use a different shell
if &shell =~# 'fish$'
    set shell=sh
endif

" Netrw
  let g:netrw_altv=1
  let g:netrw_liststyle=3

" Show unprintable characters
  set list
  set listchars=tab:»\ ,nbsp:෴,trail:※
  set colorcolumn=80

" Show commands while they're being typed
  set showcmd

" Slimux
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
map <Leader>a :SlimuxShellLast<CR>
map <Leader>k :SlimuxSendKeysLast<CR>

" Line numbers
  set number

" Folds
  let g:tex_conceal = "" "Has to be one of the most annoying things ever
  set conceallevel=0
  set nofoldenable

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
  color dracula
  hi Normal ctermbg=none

" Customize Backup Dir location
  set backupdir=~/.config/nvim/backup/
  set directory=~/.config/nvim/swap/

" JSON concealing
let g:vim_json_syntax_conceal = 0

" Clang-Format
let g:clang_format#code_style = "llvm"

" Mouse mode
set mouse=a

" Markdown
let g:markdown_syntax_conceal = 0

" https://superuser.com/questions/385553/making-the-active-window-in-vim-more-obvious
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

" Crontab stuff
if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif

" Why not zoidberg?
