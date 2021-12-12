" ~/.config/nvim/init.vim
"
"    >=>                            >=>     >=>                       
"    >=>                        >>  >=>     >=>                       
"    >=>   >==>    >=>     >=>      >=>     >=>   >==>    >=>     >=> 
"  >=>>=> >>   >=>   >=>   >=>  >=>  >=>  >=>>=> >>   >=>   >=>   >=>  
" >>  >=> >>===>>=>   >=> >=>   >=>  >=> >>  >=> >>===>>=>   >=> >=>   
" >>  >=> >>           >=>=>    >=>  >=> >>  >=> >>           >=>=>    
"  >=>>=>  >====>       >=>     >=> >==>  >=>>=>  >====>       >=>     
"
set nocompatible              " be iMproved, required
filetype off                  " required


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-Plug For Managing Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" set the runtime path to include vim-plug and initialize
call plug#begin('~/.config/nvim/plugged')


Plug 'itchyny/lightline.vim'                       " Lightline statusbar
Plug 'mengelbrecht/lightline-bufferline'           " Lightline Buffer list
Plug 'preservim/nerdtree',{'on': 'NERDTreeToggle'} " nerd tree file view
Plug 'mhinz/vim-startify'                          " startify
Plug 'jiangmiao/auto-pairs'                        " Auto-Pairs
Plug 'tpope/vim-commentary'                        " Commentary
Plug 'python-mode/python-mode', {'for': 'python', 'branch': 'develop'} " Pyhton-mode
Plug 'tpope/vim-fugitive'                          " Git Integration
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " tree-sitter (We recommend updating the parsers on update)
Plug 'lervag/vimtex'                               " Latex support




call plug#end()            " required
" Brief help
" :PlugInstall - Installs plugins
" :PlugUpdate - Install or update plugins
" :PlugUpgrade - Upgrade cim plug
" :PlugClean[!] - confirms removal of unused plugins; append `!` to auto-approve removal
" :PlugStatus - Check status of plugins
" Put your non-Plugin stuff after this line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Config files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.config/nvim/plugin/nerdtree.vim
source ~/.config/nvim/plugin/lightline.vim
source ~/.config/nvim/plugin/startify.vim
source ~/.config/nvim/plugin/color_theme.vim
source ~/.config/nvim/plugin/general.vim
source ~/.config/nvim/plugin/remaps.vim
source ~/.config/nvim/plugin/vimtex.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Other Stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Removes pipes | that act as seperators on splits
set fillchars+=vert:\ 
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org 
au! BufRead,BufNewFile *.md setlocal spell
au BufEnter *.org            call org#SetOrgFileType()
