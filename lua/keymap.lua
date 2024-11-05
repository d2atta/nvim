local nmap = require("utils").nmap
local tmap = require("utils").tmap
local vmap = require("utils").tmap
-- local imap = require("utils").imap

tmap({ "<Esc>", "<C-\\><C-n>" })
nmap({ "<C-s>", ":w<CR>" })
nmap({ "<leader>nh", "<cmd>noh<CR>" })
nmap({ "]b", "<cmd>bn<CR>" })
nmap({ "[b", "<cmd>bN<CR>" })
nmap({ "<C-w>", "<cmd>bw<CR>" })
nmap({ "<leader>n", "<cmd>set rnu! nu!<CR>" })
nmap({ "]q", ":cn<CR>" })
nmap({ "[q", ":cp<CR>" })
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

nmap({ "<leader>tc", require("utils").change_theme })
nmap({ "<leader>r", require("utils").execute })

-- vmap({ "<leader>]", ":Gen <CR>" })
-- open file_browser with the path of the current buffer
-- nmap({
-- 	"<C-n>",
-- 	function()
-- 		local oil = require("oil")
-- 		oil.toggle_float(oil.get_current_dir())
-- 	end,
-- })

-- nmap({ "<C-n>", ":Telescope file_browser path=%:p:h select_buffer=true<CR>" })

-- nmap({ "<leader>a", ":Neorg journal today <CR>" })
-- nmap({ "<leader>y", ":Neorg journal yesterday <CR>" })
-- nmap({
-- 	"<leader>sb",
-- 	function()
-- 		require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false }))
-- 	end,
-- })
-- nmap({
-- 	"<leader><space>",
-- 	function()
-- 		require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ winblend = 10 }))
-- 	end,
-- })
-- nmap({
-- 	"<leader>fp",
-- 	function()
-- 		require("telescope.builtin").find_files(
-- 			require("telescope.themes").get_ivy({ cwd = "~/.config/nvim", prompt_title = "Neovim Config" })
-- 		)
-- 	end,
-- })
-- nmap({
-- 	"<leader>sf",
-- 	function()
-- 		require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
-- 			winblend = 10,
-- 			previewer = false,
-- 		}))
-- 	end,
-- })
-- nmap({
-- 	"<leader>s/",
-- 	function()
-- 		require("telescope.builtin").live_grep({
-- 			grep_open_files = true,
-- 			prompt_title = "Live Grep in Open Files",
-- 		})
-- 	end,
-- })
-- nmap({ "<leader>sh", ":Telescope help_tags <CR>" })
-- nmap({ "<leader>sd", ":Telescope grep_string <CR>" })
-- nmap({ "<leader>sp", ":Telescope live_grep <CR>" })
-- nmap({ "<leader>?", ":Telescope oldfiles <CR>" })
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

-- Terminal
-- toggle in terminal mode
-- tmap({
-- 	"<A-i>",
-- 	function()
-- 		require("nvterm.terminal").toggle("float")
-- 	end,
-- })
-- tmap({
-- 	"<A-h>",
-- 	function()
-- 		require("nvterm.terminal").toggle("horizontal")
-- 	end,
-- })
--
-- tmap({
-- 	"<A-v>",
-- 	function()
-- 		require("nvterm.terminal").toggle("vertical")
-- 	end,
-- })
--
-- -- toggle in normal mode
-- nmap({
-- 	"<A-i>",
-- 	function()
-- 		require("nvterm.terminal").toggle("float")
-- 	end,
-- })
--
-- nmap({
-- 	"<A-h>",
-- 	function()
-- 		require("nvterm.terminal").toggle("horizontal")
-- 	end,
-- })
--
-- nmap({
-- 	"<A-v>",
-- 	function()
-- 		require("nvterm.terminal").toggle("vertical")
-- 	end,
-- })
--
-- -- new
-- nmap({
-- 	"<leader>h",
-- 	function()
-- 		require("nvterm.terminal").new("horizontal")
-- 	end,
-- })
--
-- nmap({
-- 	"<leader>v",
-- 	function()
-- 		require("nvterm.terminal").new("vertical")
-- 	end,
-- })
