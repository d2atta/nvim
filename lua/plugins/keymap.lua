local nmap = require("utils").nmap
local imap = require("utils").imap

nmap({ "<C-s>", ":w<CR>" })
nmap({ "<leader>nh", "<cmd>noh<CR>" })
nmap({ "<leader>bn", "<cmd>bn<CR>" })
nmap({ "<C-w>", "<cmd>bw<CR>" })
nmap({ "<leader>tt", "<cmd>vnew<CR>" })
nmap({ "<leader>n", "<cmd>set rnu! nu!<CR>" })
nmap({ "]q", ":cn<CR>" })
nmap({ "[q", ":cp<CR>" })
nmap({ "<C-a>", "<cmd>%y <CR>" })
nmap({ "<C-n>", "<cmd>NvimTreeToggle<CR>" })
nmap({
	"<leader>ff",
	function()
		-- Choose theme
		require("telescope.builtin").find_files(require("telescope.themes").get_dropdown())
	end,
})
nmap({
	"<leader>fp",
	function()
		require("telescope.builtin").find_files(require("telescope.themes").get_ivy({ cwd = "~/.config/nvim" }))
	end,
})
nmap({
	"<leader>tc",
	function()
		require("utils").change_theme({})
	end,
})
nmap({ "<leader>r", require("utils").execute })

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

-- Tab naviagtion
nmap({ "<Tab>", "<cmd>bn<CR>" })
nmap({ "<S-Tab>", "<cmd>bp<CR>" })
