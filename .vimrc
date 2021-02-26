"
" VIM PLUG: https://github.com/junegunn/vim-plug
"
" Specify a directory for plugins
" call plug#begin('~/.vim/plugged')

" Colors
" Plug 'sainnhe/gruvbox-material'
" Plug 'tomasr/molokai'
" Plug 'AlessandroYorba/Monrovia'
" Plug 'jnurmine/Zenburn'
" Plug 'altercation/vim-colors-solarized', { 'set': 'all' }


" Plug 'thiagoalessio/rainbow_levels.vim'

" Editing
" Plug 'junegunn/vim-easy-align'
" Plug 'tpope/vim-surround'
" Plug 'tmhedberg/SimpylFold'
" Plug 'bronson/vim-trailing-whitespace'
" Plug 'ConradIrwin/vim-bracketed-paste'

" Lang
" Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
" Plug 'octol/vim-cpp-enhanced-highlight'

" Lint
" Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' }
" Plug 'nvie/vim-flake8'

" Handy stuff
" Plug 'wincent/terminus'

" Autocomplete
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Close the plugin system
" call plug#end()



"
" VUNDLE https://github.com/VundleVim/Vundle.vim#about
"
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'tpope/vim-surround'
    Plugin 'sainnhe/gruvbox-material'   " https://github.com/sainnhe/gruvbox-material
    Plugin 'bronson/vim-trailing-whitespace'
    Plugin 'ConradIrwin/vim-bracketed-paste'
    Plugin 'ycm-core/YouCompleteMe'
    " Plugin 'scrooloose/syntastic'
    " Plugin 'itchyny/lightline.vim'

    " The following are examples of different formats supported.
    " Keep Plugin commands between vundle#begin/end.
    " plugin on GitHub repo
    " Plugin 'tpope/vim-fugitive'

    " plugin from http://vim-scripts.org/vim/scripts.html
    " Plugin 'L9'
    " Git plugin not hosted on GitHub
    " Plugin 'git://git.wincent.com/command-t.git'

    " git repos on your local machine (i.e. when working on your own plugin)
    " Plugin 'file:///home/gmarik/path/to/plugin'

    " The sparkup vim script is in a subdirectory of this repo called vim.
    " Pass the path to set the runtimepath properly.
    " Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

    " Install L9 and avoid a Naming conflict if you've already installed a
    " different version somewhere else.
    " Plugin 'ascenator/L9', {'name': 'newL9'}

    " All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" END VUNDLE
"

" GRUVBOX-MATERIAL: https://github.com/sainnhe/gruvbox-material
" Important!!
if has('termguicolors')
  set termguicolors
endif

" For dark or light version.
set background=dark
" set background=light

" Set contrast.
" This configuration option should be placed before `colorscheme gruvbox-material`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_palette = 'original'

" from: https://github.com/sainnhe/gruvbox-material/issues/5#issuecomment-729586348
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

colorscheme gruvbox-material


" YouCompleteMe: https://github.com/ycm-core/YouCompleteMe#options
set completeopt=menu,popup,popuphidden
" set completepopup=height:10,width:60,highlight:InfoPopup
" let g:ycm_auto_hover=''  " https://stackoverflow.com/questions/64480651/youcompleteme-function-preview-popup-balloon-in-new-version

"  Syntastic: https://vimawesome.com/plugin/syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" Lightline config: https://github.com/itchyny/lightline.vim
" set laststatus=2
" set noshowmode
" let g:lightline = {
"      \ 'colorscheme': 'molokai',
"      \ }



" Colors
" colorscheme solarized
" colorscheme monrovia
" colorscheme zenburn
" :silent! colorscheme molokai

" Rainbow Levels
" map <leader>l :RainbowLevelsToggle<cr>
highlight Cursor ctermbg=Green

set incsearch	" incremental search
set hlsearch 	" search highlighting
set visualbell  " no beeping
set encoding=utf-8
set cursorline
" set lazyredraw
let python_highlight_all=1
syntax on

" let g:TerminusCursorShape=1
" let g:TerminusMouse=0
" let g:TerminusBracketedPaste=1
" let g:TerminusAssumeITerm=1

" Whitespace
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" set laststatus=1


" Cursor: https://stackoverflow.com/questions/6230490/how-i-can-change-cursor-color-in-color-scheme-vim
" set cursorcolumn
" hi CursorColumn ctermbg=8
" if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  " let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  " let &t_EI = "\<Esc>]12;red\x7"
  " silent !echo -ne "\033]12;red\007"
  " reset cursor when vim exits
  " autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal
" endif


" Enable folding
" set foldmethod=indent
" set foldlevel=99

" Enable folding with the spacebar
" nnoremap <space> za

" Lets us share buffers outside vim
" set clipboard=unnamed

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
" set cursorcolumn

" :hi MatchParen cterm=none ctermfg=none ctermbg=green


" KITE: https://github.com/kiteco/plugins/tree/master/vim
" this prevents the annoying preview window from popping up on top
" set completeopt-=preview
" autocmd CompleteDone * if !pumvisible() | pclose | endif
" let g:kite_tab_complete=1
" set statusline=%<%f\ %h%m%r%{kite#statusline()}%=%-14.(%l,%c%V%)\ %P
" set laststatus=2  " always display the status line
