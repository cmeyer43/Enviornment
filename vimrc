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

set tags+=~/.vim/cpp_tags
set tags+=~/.vim/python_tags
set tags+=./tags
set tags+=./../tags
set tags+=./*/tags
set tags+=./../*/tags
set tags+=./../../tags
set tags+=./ptags
set tags+=./../ptags
set tags+=./*/ptags
set tags+=./../*/ptags
set tags+=./../../ptags

map <C-g> :!ctags -R --sort=yes --languages=c++ --c++-kinds=+p --fields+ias --extra=+q -I_GLIBCXX_NOEXCEPT --exclude=*/build/* . && ctags -f ptags -R --languages=python --python-kinds=-i --exclude=*/build/* --fields=+ias --extra=+q . <CR>
map <C-f> <C-]>
map <C-b> <C-t>

map <C-h> :tabprev <CR>
map <C-l> :tabnext <CR>
map <C-j> :tabnew <CR>
" map <C-k> :tabclose <CR>
inoremap <C-A-j> <C-w> <C-j>
inoremap <C-A-k> <C-w> <C-k>
inoremap <C-A-h> <C-w> <C-h>
inoremap <C-A-l> <C-l> <C-l>

