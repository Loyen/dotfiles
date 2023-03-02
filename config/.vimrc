"Encoding
set encoding=utf8

" Plugins

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

Plug  'bling/vim-airline'
Plug  'kien/ctrlp.vim'
Plug  'airblade/vim-gitgutter'
Plug  'matze/vim-move'
Plug  'posva/vim-vue'
Plug  'sickill/vim-monokai'

call plug#end()

" Enable syntax highlighting
syntax enable
silent!colorscheme monokai

" Enable filetype plugins
filetype plugin on
filetype indent on

" Enable mouse support
set mouse=a

" Show current position
set ruler

" Show line number
set number

" Highlight search results
set hlsearch

" Show matching bracket
set showmatch

" Smart tabs
set smarttab

" Auto indent
set autoindent

" Tab size 4 spaces
set expandtab
set shiftwidth=4
set tabstop=4

" Always show status line
set laststatus=2

" Height of command bar
set cmdheight=1

let g:airline_powerline_fonts = 1
