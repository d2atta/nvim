local nmap = require("utils").nmap
local tmap = require("utils").tmap
local vmap = require("utils").tmap
-- local imap = require("utils").imap

tmap({ "<Esc>", "<C-\\><C-n>" })
nmap({ "<C-s>", ":w<CR>" })
nmap({ "<leader>nh", "<cmd>noh<CR>" })
-- nmap({ "]b", "<cmd>bn<CR>" })
-- nmap({ "[b", "<cmd>bN<CR>" })
-- nmap({ "]q", ":cn<CR>" })
-- nmap({ "[q", ":cp<CR>" })
nmap({ "<C-w>", "<cmd>bw<CR>" })
nmap({ "<leader>n", "<cmd>set rnu! nu!<CR>" })
nmap({ "<C-a>", "<cmd>%y <CR>" })

-- split window easily
nmap({ "<leader>wv", ":vsplit<CR>" })
nmap({ "<leader>wh", ":split<CR>" })

-- Remap splits navigation to just CTRL + hjkl
nmap({ "<C-h>", "<C-w>h" })
nmap({ "<C-j>", "<C-w>j" })
nmap({ "<C-k>", "<C-w>k" })
nmap({ "<C-l>", "<C-w>l" })

-- Make adjusing split sizes a bit more friendly
nmap({ "<C-Left>", ":vertical resize +3<CR>" })
nmap({ "<C-Right>", ":vertical resize -3<CR>" })
nmap({ "<C-Up>", ":resize +3<CR>" })
nmap({ "<C-Down>", ":resize -3<CR>" })

-- Change 2 split windows from vert to horiz or horiz to vert
nmap({ "<leader>th", "<C-w>t<C-w>H" })
nmap({ "<leader>tk", "<C-w>t<C-w>K" })

-- Visual moving
vmap({ "J", ":m '>+1<CR>gv=gv'" })
vmap({ "K", ":m '<-2<CR>gv=gv'" })

nmap({ "<leader>tc", require("utils").change_theme, { desc = "[T]heme [C]hange" } })
nmap({ "<leader>r", require("utils").execute })

-- Telescope
nmap({ "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "[S]earch [H]elp" } })
nmap({ "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "[S]earch [K]eymaps" } })
nmap({ "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "[S]earch [K]eymaps" } })
nmap({ "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "[S]earch by [G]rep" } })
nmap({ "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "[S]earch current [W]ord" } })
nmap({ "<leader>s.", "<cmd>Telescope oldfiles<cr>", { desc = '[S]earch Recent Files ("." for repeat)' } })
nmap({ "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "[ ] Find existing buffers" } })
nmap({ "<leader>fb", "<cmd>Telescope file_browser<cr>", { desc = "[F]ile [B]rowser" } })

-- Terminal
tmap({
	"<leader>tt",
	function()
		require("nvterm.terminal").toggle("float")
	end,
	desc = "toggle in terminal mode",
})

nmap({
	"<leader>tt",
	function()
		require("nvterm.terminal").toggle("float")
	end,
	desc = "toggle in terminal mode",
})
-- open file_browser with the path of the current buffer
nmap({
	"<C-n>",
	function()
		local oil = require("oil")
		oil.toggle_float(oil.get_current_dir())
	end,
})

-- vmap({ "<leader>]", ":Gen <CR>" })
-- nmap({ "<leader>a", ":Neorg journal today <CR>" })
-- nmap({ "<leader>y", ":Neorg journal yesterday <CR>" })
-- nmap({ "<leader>z", ":Twilight <CR>" })

-- Trouble
-- nmap({
-- 	"<leader>xx",
-- 	function()
-- 		require("trouble").toggle()
-- 	end,
-- })
-- nmap({
-- 	"<leader>xw",
-- 	function()
-- 		require("trouble").toggle("workspace_diagnostics")
-- 	end,
-- })
-- nmap({
-- 	"<leader>xd",
-- 	function()
-- 		require("trouble").toggle("document_diagnostics")
-- 	end,
-- })
-- nmap({
-- 	"gR",
-- 	function()
-- 		require("trouble").toggle("lsp_references")
-- 	end,
-- })
