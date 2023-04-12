local opt = vim.opt
-- local cmd = vim.cmd
local g = vim.g

opt.path = table.concat({ "**" }) -- Searches current directory recursively.
opt.wildignore = { "*.o,*~,*.pyc" }
opt.wildmenu = true -- Display all matches when tab complete.
opt.incsearch = true -- Incremental search
opt.hidden = true -- Needed to keep multiple buffers open
opt.lazyredraw = true
opt.list = true -- show invisible characters
opt.listchars = {
        eol = "↲",
        tab = "» ",
        trail = "·",
        extends = "<",
        precedes = ">",
        conceal = "┊",
        nbsp = "␣",
}
opt.undofile = true
opt.laststatus = 3
opt.cmdheight = 0
opt.ruler = false
opt.pumheight = 10 -- Makes Popup smaller
opt.termguicolors = true -- 256 colors
opt.expandtab = true -- Change tabs to spaces
opt.cul = true -- cursor line
opt.ruler = true -- set Ruler
opt.background = "dark" -- Dark background
opt.encoding = "utf-8" -- Character encoding
opt.mouse = "nicr" -- Mouse scrolling support
opt.mousemodel = "" -- disable right click
opt.clipboard = "unnamedplus" -- Copy/paste anywhere
opt.scrolloff = 8
opt.colorcolumn = "80"
opt.showmode = false
opt.conceallevel = 2
opt.concealcursor = "nc"
opt.foldmethod = "expr" -- Fold Method
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldtext = [[ substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
opt.fillchars = { fold = " " }
opt.foldnestmax = 3
opt.foldminlines = 1
-- opt.shortmess:append("sI") -- Removes vim intro
opt.whichwrap:append("<>[]hl")
opt.splitright = true
opt.splitbelow = true
--
-- Global options
g.tabstop = 2
g.shiftwidth = 2
g.softtabstop = 2
g.nowrap = true -- Dont wrap text
g.nobackup = true -- No auto backups
g.noswapfile = true -- No swap
g.t_Co = 256 -- Set if term supports 256 colors.
g.mapleader = " "
g.maplocalleader = ","
g.loaded_python_provider = 0
g.python3_host_prog = "/usr/bin/python"
