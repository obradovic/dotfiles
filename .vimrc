" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Editing
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'frazrepo/vim-rainbow'

" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Lang

" Lint
Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' }

" Colors
Plug 'jamescherti/vim-tomorrow-night-deepblue'
Plug 'sainnhe/gruvbox-material'
" Plug 'rebelot/kanagawa.nvim'
" Plug 'folke/tokyonight.nvim'
" Plug 'rose-pine/neovim'

" Close the plugin system
call plug#end()

" Colors
" colorscheme tomorrow-night-deepblue
 colorscheme gruvbox-material
" colorscheme kanagawa
" colorscheme tokyonight-night

let g:rainbow_active = 1

inoremap <silent><expr> <TAB> pumvisible() ? coc#pum#confirm() : "\<TAB>"
" inoremap <silent><expr> <CR> pumvisible() ? coc#pum#confirm() : "\<CR>"

" Search
set incsearch	" incremental search
set hlsearch 	" search highlighting

set visualbell  " no beeping
set encoding=utf-8
" set lazyredraw
let python_highlight_all=1
syntax on

" set showmatch
" set matchtime=2
" if !exists('g:loaded_matchparen')
" runtime plugin/matchparen.vim
" endif
highlight MatchParen cterm=bold ctermbg=darkblue guibg=LightYellow

" Whitespace
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Indent
set autoindent
set smartindent

" Numbers everywhere
set ruler
set number
set relativenumber
set cursorline

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" Lets us share buffers outside vim
set clipboard=unnamed

" Annoying temporary files
set backupdir=/tmp//,.
set directory=/tmp//,.

" em-dash to regular dash, just hit "\d"
nnoremap <leader>d :%s/—/-/g<CR>

" Replace word under cursor everywhere visually
nnoremap <leader>r :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" now handled by vim-bracketed-paste plugin
" set paste

" mouse scrolling
" set mouse=a
