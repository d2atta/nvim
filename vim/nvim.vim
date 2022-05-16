" Legacyyy"
set nocompatible              " be iMproved, required
filetype off                  " required

" General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
set path+=**                    " Searches current directory recursively.
set wildmenu                    " Display all matches when tab complete.
set incsearch                   " Incremental search
set hidden                      " Needed to keep multiple buffers open
set nobackup                    " No auto backups
set noswapfile                  " No swap
set t_Co=256                    " Set if term supports 256 colors.
set list                        " show invisble characters
"set number relativenumber       " Display line numbers
set clipboard=unnamedplus       " Copy/paste anywhere
set pumheight=10                " Makes Popup smaller
set conceallevel=0              " Show `` in Markdown
set ruler
set nowrap
set background=dark
let g:rehsh256 = 1
let mapleader = " "
au! BufWritePost $MYVIMRC source %  "auto source when writting init.vim
set mouse=nicr
let g:python_highlight_all = 1
let g:python3_host_prog=expand("/usr/bin/python3")

" Remaps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-_> gcc 
map <Leader>tt :vnew term://fish<CR>
map <C-s> :w<CR>
map <C-q> :bw<CR>
map <Leader>r :!python3 % < input.txt<CR>
map <leader>s :Startify <CR>
map <Leader>nh :noh<CR>
map bn :bn<CR>
map bw :bw<CR>
map <leader>n :set number !<CR>

" Splits and Tabbed Files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow splitright

" split window easily
noremap <Leader>wv :vsplit<CR>
noremap <Leader>wh :split<CR>

" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Make adjusing split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K


" Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
set statusline=                          " left align
set statusline+=%1*\ %F                  " filename
set statusline+=%1*\ 
set statusline+=%3*\%h%m%r               " file flags (help, read-only, modified)
set statusline+=%=                       " right align
set statusline+=%3*\ \ \ 
set statusline+=%3*\[%l/%L]\             " line count
set statusline+=%1*\ %y                   " file type
hi User1 ctermbg=black ctermfg=red
hi User2 ctermbg=green ctermfg=black
hi User3 ctermbg=black ctermfg=blue

" Load view
autocmd BufWinLeave *.* mkview
" autocmd BufWinEnter *.* silent loadview
