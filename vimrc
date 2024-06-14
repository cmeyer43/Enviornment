" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible        " Use Vim defaults instead of 100% vi compatibility

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

let skip_defaults_vim=1

set shiftwidth=4

set tabstop=4

set expandtab

syntax on

set number

set ignorecase

set backspace=indent,eol,start
set showcmd
" set nowrap
set encoding=utf8

"VUNDLE
" More config
set smarttab
" set laststatus=2
" set cursorline
set background=dark
set history=100
set autoread
filetype plugin on
filetype indent on
set ruler
" set smartcase
set hlsearch
set incsearch

inoremap jj <esc>
