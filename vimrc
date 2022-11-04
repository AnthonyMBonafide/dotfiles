set nocompatible
filetype on
set encoding=utf-8
filetype plugin on
filetype indent on
syntax on
set noswapfile

call plug#begin('~/.vim/plugged')

Plug 'rust-lang/rust.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'scrooloose/nerdtree'
Plug 'NLKNguyen/papercolor-theme'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

set hlsearch
set incsearch
set ignorecase
set smartcase
set autowrite
set number
set relativenumber
set autowrite
set tabstop=4
set autoindent
set expandtab
set background=dark
set t_Co=256

inoremap jk <esc>

colorscheme PaperColor

let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

"CTRL-t to toggle tree view with CTRL-t
nmap <silent> <C-t> :NERDTreeToggle<CR>

autocmd VimEnter * NERDTree
autocmd BufEnter * NERDTreeMirror


