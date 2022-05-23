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
	{ "lewis6991/impatient.nvim" },
	{ "wbthomason/packer.nvim", event = "VimEnter" },

	{
		-- code highlighting
		"nvim-treesitter/nvim-treesitter",
		opt = true,
		event = "BufRead",
		config = function()
			require("plugins").treesitter()
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		module = "telescope",
		cmd = "Telescope",
		config = function()
			require("plugins").telescope()
		end,
	}, -- Find files

	{
		"lewis6991/gitsigns.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"kyazdani42/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = function()
			require("plugins").nvimtree()
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
		"L3MON4D3/LuaSnip",
		after = "mini",
		config = function()
			require("plugins").Luasnip()
		end,
	},

	{
		"$HOME/.config/nvim/lua/mini",
		event = "BufRead",
		config = function()
			require("plugins").mini()
		end,
	},
}
---}}}

--{{{ Packer
require("impatient").enable_profile()
vim.cmd([["packadd packer.nvim"]])
local packer = require("packer")
packer.init({
	display = {
		open_fn = require("packer.util").float,
	},
	compile_on_sync = true,
	auto_clean = true,
})
packer.startup({ plugins })
---}}}

--{{{Global
require("plugins.options")
require("plugins.keymap")
--}}}
