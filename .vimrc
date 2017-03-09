" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Colors
Plug 'tomasr/molokai'
Plug 'AlessandroYorba/Monrovia'
Plug 'jnurmine/Zenburn'
Plug 'altercation/vim-colors-solarized', { 'set': 'all' }

" Editing
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
" Plug 'tmhedberg/SimpylFold'

" Lang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'octol/vim-cpp-enhanced-highlight'

" Lint
Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' }
Plug 'nvie/vim-flake8'

" Close the plugin system
call plug#end()

" Colors
" colorscheme solarized
" colorscheme monrovia
colorscheme molokai
" colorscheme zenburn

set ruler
set incsearch	" incremental search
set hlsearch 	" search highlighting
set visualbell  " no beeping
set paste
set encoding=utf-8
set cursorline
set lazyredraw
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
