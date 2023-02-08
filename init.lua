---------------------------------------------------------------------------
--                             N V I M
---------------------------------------------------------------------------
-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
-- Theme
vim.g.theme = "palenight"
--{{{ Package manager
local plugins = {
	-- Packer can manage itself
	{ "nvim-lua/plenary.nvim" }, -- Functions for Nvim
	{ "wbthomason/packer.nvim" }, -- Packer
	-- Twilight
	{
		"folke/twilight.nvim",
		config = function()
			require("plugins").twilight()
		end
	},

	-- code highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugins").treesitter()
		end,
	},
	-- Icons
	{
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				override = {
					org = {
						icon = "",
						color = "#428850",
					},
				},
			})
		end,
	},

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
		event = "UIEnter",
		config = function()
			require("plugins").lir()
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
		event = "UIEnter",
		ft = { "python", "lua", "rust" },
		setup = function()
			vim.defer_fn(function()
				require("packer").loader("nvim-lspconfig")
			end, 0)
		end,
		config = function()
			require("plugins.lsp").lspconfig()
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("plugins.lsp").nullLs()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			require "plugins.cmp"
		end,
	},
	{"hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
	{"hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" },
	{"hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" },
	{"hrsh7th/cmp-path", after = "cmp-buffer" },

	-- Misc
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VimEnter",
		config = function()
			require("plugins").blankline()
		end
	},
	{
		"$HOME/.config/nvim/lua/mini",
		event = "VimEnter",
		setup = function()
			vim.defer_fn(function()
				vim.cmd([[if &ft == "packer" | echo "" | else | silent! e %]])
			end, 0)
		end,
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
--{{{Autocommands
-- Source after save
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerCompile",
	group = packer_group,
	pattern = "init.lua",
})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
--}}}
