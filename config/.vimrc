"Encoding
set encoding=utf8

" Enable syntax highlighting
syntax enable
colorscheme monokai

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

" Plugins

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'matze/vim-move'
Plugin 'posva/vim-vue'

call vundle#end()

