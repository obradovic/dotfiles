" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

set nocompatible               " be iMproved
" filetype off                   " required!

" set rtp+=~/.vim/bundle/vundle/
" call vundle#rc()

" let Vundle manage Vundle
" required! 
" Bundle 'gmarik/vundle'

" my bundles here
" Bundle 'tpope/vim-fugitive'


filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..


set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set cindent
set autoindent
set paste

set ru
set sc
set wmnu

set backupdir=/tmp
set dir=/tmp

set incsearch
set hlsearch
set ruler
set showcmd
syntax enable
set background=dark
colorscheme solarized
" filetype on

" :hi MatchParen cterm=underline ctermbg=none ctermfg=none
:hi MatchParen cterm=bold ctermbg=none ctermfg=green

set guioptions-=T
set guifont=Droid\ Sans\ Mono:h9

" Lets you scroll with a mouse (but must use iTerm2...)
" set mouse=a
" map <ScrollWheelUp> <C-Y>
" map <ScrollWheelDown> <C-E>

" highlight Cursor guifg=green guibg=green
" highlight iCursor guifg=green guibg=green
" set guicursor=n-v-c:block-Cursor
" set guicursor+=i:ver100-iCursor
" set guicursor+=n-v-c:blinkon0
" set guicursor+=i:blinkwait10

