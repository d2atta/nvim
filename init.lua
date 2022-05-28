------------------------------------------------------------------------------
--                             N V I M
------------------------------------------------------------------------------
-- Theme
vim.g.theme = "monekai"
--{{{ Package manager
local plugins = {
	-- Packer can manage itself
	{ "nvim-lua/plenary.nvim" }, -- Functions for Nvim
	{ "nathom/filetype.nvim" }, -- filetype
	{ "wbthomason/packer.nvim" }, -- Packer

	-- code highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		opt = true,
		event = "BufRead",
		config = function()
			require("plugins").treesitter()
		end,
	},
	-- Icons
	{ "kyazdani42/nvim-web-devicons" },

	-- Find files
	{
		"nvim-telescope/telescope.nvim",
		module = "telescope",
		cmd = "Telescope",
		config = function()
			require("plugins").telescope()
		end,
	},
	{
		"tamago324/lir.nvim",
		config = function()
			require("plugins.init").lir()
		end,
	},

	-- Git sign
	{
		"lewis6991/gitsigns.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- lsp
	{
		"neovim/nvim-lspconfig",
		module = "lspconfig",
		after = "mini",
		event = "BufRead",
		ft = { "python", "lua", "rust" },
		config = function()
			require("plugins.lsp").lspconfig()
		end,
		setup = function()
			vim.defer_fn(function()
				vim.cmd([[if &ft == "packer" | echo "" | else | silent! e %]])
			end, 0)
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opt = true,
		after = "nvim-lspconfig",
		config = function()
			require("plugins.lsp").nullLs()
		end,
	},
	{
		"$HOME/.config/nvim/lua/mini",
		event = "UIEnter",
		config = function()
			require("plugins").mini()
		end,
	},
}
---}}}

--{{{ Packer
local packer = require("packer")
packer.init({
	display = {
		open_fn = require("packer.util").float,
	},
	compile_on_sync = true,
	auto_clean = true,
	profile = {
		enable = true,
		threshold = 1,
	},
})
packer.startup({ plugins })
---}}}

--{{{Global
require("plugins.options")
require("plugins.keymap")
--}}}
