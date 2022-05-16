------------------------------------------------------------------------------
------------------------------ N V I M ---------------------------------------
------------------------------------------------------------------------------
--{{{ constants
vim.g.did_load_filetypes = 1
require('impatient').enable_profile()
local set = vim.opt
local cmd = vim.cmd
local g = vim.g
local icons = require('mini.icons')
local map = function(key)
  local opts = {noremap = true, silent = true}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end
  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end
---}}}

--{{{ Misc
-- au! filetype c,cpp nnoremap <leader>fw :w <bar> !g++ -std=c++17 -O2 -g -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG -Wshadow -Wall % -o out && cat inp \| ./out <CR>
cmd [[
au! BufWritePost $MYVIMRC source % | setlocal statusline=%!v:lua.MiniStatusline.active() | PackerCompile
au! BufRead $MYVIMRC setlocal foldmethod=marker
au! filetype cpp,python,rust set rnu nu
]]
-- disable some builtin vim plugins
local disabled_built_ins = {
   "did_load_filetypes",
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end
--}}}

--{{{ Package manager
local plugins = {
  -- Packer can manage itself
   {'nvim-lua/plenary.nvim'},     -- Functions for Nvim
   {'nathom/filetype.nvim'},      -- filetype
   {'lewis6991/impatient.nvim'},
   {'wbthomason/packer.nvim',
     event = "VimEnter"
   },
   {'nvim-treesitter/nvim-treesitter',
     opt = true,
     event = 'BufRead',
     config = [[require('plugins.tree_sitter')]],
   }, -- code highlighting
   {'neovim/nvim-lspconfig',
     module = 'lspconfig',
     after = "mini",
     event = 'BufRead',
     ft = {'python', 'cpp', 'lua', 'c'},
     config = [[require('plugins.lsp')]],
     setup = function()
         vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
         end, 0)
     end
   }, -- LSP
   {'nvim-telescope/telescope.nvim',
     module = "telescope",
     cmd = "Telescope",
     config = [[require('plugins.telescope')]],
   }, -- Find files
   {
     'sbdchd/neoformat',
     opt = true,
     cmd = 'Neoformat',
   {
     'lewis6991/gitsigns.nvim',
     after = "nvim-lspconfig",
     config = function()
	   require("gitsigns").setup()
     end
   },
   },
   {
     'jose-elias-alvarez/null-ls.nvim',
     after = "nvim-lspconfig",
     config = [[require("plugins.null-ls")]]
   },
   {
    'kyazdani42/nvim-tree.lua',
     cmd = { "NvimTreeToggle", "NvimTreeFocus" },
     config = function() require'nvim-tree'.setup {} end
   },
   {
    '$HOME/.config/nvim/lua/mini',
     event = 'BufRead',
     config = function() require 'plugins.mini' end
   }
}

cmd [[packadd packer.nvim]]
local packer = require('packer')
packer.init {
  display = {
    open_fn= require('packer.util').float,
  },
  -- compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua',
  compile_on_sync = true,
  auto_clean = true,
}
packer.startup {plugins}
--}}}
------------------------------------------------------------------------------
--                               UI
------------------------------------------------------------------------------
--{{{ General Options
set.path = table.concat({"**"})  -- Searches current directory recursively.
set.wildignore = {'*.o,*~,*.pyc'}
set.wildmenu = true              -- Display all matches when tab complete.
set.incsearch = true             -- Incremental search
set.hidden = true                -- Needed to keep multiple buffers open
set.lazyredraw = true
set.list = true                  -- show invisible characters
set.undofile = true
set.pumheight = 10               -- Makes Popup smaller
set.termguicolors = true         -- 256 colors
set.cul = true                   -- cursor line
set.ruler = true                 -- set Ruler
set.background = "dark"          -- Dark background
set.encoding = "utf-8"           -- Character encoding
set.mouse = "nicr"               -- Mouse scrolling support
set.clipboard = "unnamedplus"    -- Copy/paste anywhere
set.showmode = false
set.foldmethod = 'expr'          -- Fold Method
set.foldexpr = 'nvim_treesitter#foldexpr()'
set.shortmess:append "sI"
set.whichwrap:append "<>[]hl"
set.splitright = true
set.splitbelow = true

-- Global options
g.tabstop = 4
g.nowrap = true                  -- Dont wrap text
g.nobackup = true                -- No auto backups
g.noswapfile = true              -- No swap
g.t_Co=256                       -- Set if term supports 256 colors.
g.mapleader = " "
g.maplocalleader = ","
g.loaded_python_provider = 0
g.python3_host_prog = '/usr/bin/python'
--}}}

--{{{ Keybindings
map { 'n', '<C-s>', '<cmd>w<CR>' }
map { 'n', '<leader>nh',':noh<CR>' }
map { 'n', '<leader>bn', ':bn<CR>' }
map { 'n', '<C-w>', ':bw<CR>' }
map { 'n', '<leader>tt', ':vnew<CR>' }
map { 'n', '<leader>n', ':set rnu! nu!<CR>' }
map { 'n', '<C-a>', ':%y <CR>' }
map { 'n', '<C-n>', ':NvimTreeToggle<CR>' }
map { 'n', '<leader>ff', "<cmd>Telescope find_files theme=dropdown <cr>" }
map { 'n', '<leader>fp', '<cmd>Telescope find_files theme=ivy prompt_prefix=Configs> cwd=~/.config/nvim <CR>' }
map { 'n', '<C-c>', "<cmd>lua require('plugins.change_theme').setup()<CR>" }
map { 'n', '<leader>ex', ':w <bar> !g++ -std=c++17 -O2 -g -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG -Wshadow -Wall % -o out && cat inp | ./out <CR>'}
map { 'n', '<localleader>r', ':!python3 % < input.txt<CR>' }

-- split window easily
map{ 'n', '<leader>wv', ':vsplit<CR>' }
map{ 'n', '<leader>wh', ':split<CR>' }

-- Remap splits navigation to just CTRL + hjkl
map { 'n', '<C-h>', '<C-w>h' }
map { 'n', '<C-j>', '<C-w>j' }
map { 'n', '<C-k>', '<C-w>k' }
map { 'n', '<C-l>', '<C-w>l' }

-- Make adjusing split sizes a bit more friendly
map { 'n', '<C-Left>', ':vertical resize +3<CR>' }
map { 'n', '<C-Right>', ':vertical resize -3<CR>' }
map { 'n', '<C-Up>', ':resize +3<CR>' }
map { 'n', '<C-Down>', ':resize -3<CR>' }

-- Change 2 split windows from vert to horiz or horiz to vert
map { 'n', '<leader>th', '<C-w>t<C-w>H' }
map { 'n', '<leader>tk', '<C-w>t<C-w>K' }

-- Tab naviagtion
map{'n', [[<Tab>]], ":bn<CR>" }
map{'n', [[<S-Tab>]],":bp<CR>" }


-- Completion & Auto-pairs
map{'i', [[<Tab>]],   [[pumvisible() ? "\<C-n>" : "\<Tab>"]] ,  expr = true }
map{'i', [[<S-Tab>]], [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], expr = true }

--}}}

