local opt = vim.opt
-- local cmd = vim.cmd
local g = vim.g

local grp = vim.api.nvim_create_augroup("source_nvimrc", {})
vim.api.nvim_create_autocmd("BufWritePost", { pattern = { vim.env.MYVIMRC }, command = "luafile %", group = grp })

-- local alpha_grp = vim.api.nvim_create_augroup("Alpha_Greeter", {})
-- vim.api.nvim_create_autocmd("FileType", { pattern = "alpha", command = "set laststatus=0 noruler", group = alpha_grp })
-- vim.api.nvim_create_autocmd(
-- 	{ "BufUnload", "FileType" },
-- 	{ pattern = "alpha", command = "set laststatus=3", group = alpha_grp }
-- )

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
g.did_load_filetypes = 1
for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

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
opt.ruler = false
opt.pumheight = 10 -- Makes Popup smaller
opt.termguicolors = true -- 256 colors
-- opt.expandtab = true          -- Change tabs to spaces
opt.cul = true -- cursor line
opt.ruler = true -- set Ruler
opt.background = "dark" -- Dark background
opt.encoding = "utf-8" -- Character encoding
opt.mouse = "nicr" -- Mouse scrolling support
opt.clipboard = "unnamedplus" -- Copy/paste anywhere
opt.showmode = false
opt.foldmethod = "expr" -- Fold Method
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldtext = [[ substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
opt.fillchars = { fold = " " }
opt.foldnestmax = 3
opt.foldminlines = 1
opt.shortmess:append("sI")
opt.whichwrap:append("<>[]hl")
opt.splitright = true
opt.splitbelow = true

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
