" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Colors
Plug 'tomasr/molokai'
Plug 'jnurmine/Zenburn'
Plug 'altercation/vim-colors-solarized', { 'set': 'all' }
Plug 'nordtheme/vim'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/everforest'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/edge'

" Editing
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
" Plug 'tmhedberg/SimpylFold'
Plug 'bronson/vim-trailing-whitespace'
Plug 'ConradIrwin/vim-bracketed-paste'

" Lang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'octol/vim-cpp-enhanced-highlight'

" Lint
Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' }
" Plug 'nvie/vim-flake8'

" Close the plugin system
call plug#end()

" Colors
" colorscheme solarized
" colorscheme monrovia
" colorscheme molokai
" colorscheme nord 
" colorscheme zenburn
" colorscheme gruvbox
" colorscheme gruvbox-material
" colorscheme edge
colorscheme everforest


set incsearch	" incremental search
set hlsearch 	" search highlighting
set visualbell  " no beeping
set encoding=utf-8
set cursorline
" set lazyredraw
let python_highlight_all=1
syntax on

" Whitespace
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" Lets us share buffers outside vim
set clipboard=unnamed

" set guioptions-=T
" set guifont=Droid\ Sans\ Mono:h9

" Lets you scroll with a mouse 
" set mouse=a
" map <ScrollWheelUp> <C-Y>
" map <ScrollWheelDown> <C-E>

" Annoying temporary files
set backupdir=/tmp//,.
set directory=/tmp//,.

" now handled by vim-bracketed-paste plugin
" set paste

set ruler
