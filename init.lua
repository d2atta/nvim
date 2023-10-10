---------------------------------------------------------------------------
--                             N V I M
---------------------------------------------------------------------------
-- Install lazy.vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Theme
vim.g.theme = "github-dark"

--{{{ Package manager
local plugins = {
	{ "nvim-lua/plenary.nvim", lazy = true },
	-- code highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugins").treesitter()
		end,
	},
	-- Icons
	{ "kyazdani42/nvim-web-devicons", lazy = true },
	-- Find files
	{
		"nvim-telescope/telescope.nvim",
		name = "telescope",
		cmd = "Telescope",
		config = function()
			require("plugins").telescope()
		end,
		dependencies = {
			"nvim-treesitter/playground",
		},
	},
	{
		"tamago324/lir.nvim",
		lazy = true,
		config = function()
			require("plugins").lir()
		end,
	},
	-- lsp
	{
		"neovim/nvim-lspconfig",
		module = "lspconfig",
		ft = { "python", "lua", "sh", "cpp", "markdown" },
		config = function()
			require("plugins.lsp").lspconfig()
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"aspeddro/cmp-pandoc.nvim",
			{ "lewis6991/gitsigns.nvim", config = true },
			{
				"hrsh7th/nvim-cmp",
				config = function()
					require("plugins.cmp")
				end,
			},
			{
				"stevearc/conform.nvim",
				event = { "BufWritePre" },
				cmd = { "ConformInfo" },
				config = function()
					require("plugins.lsp").conform()
				end,
			},
		},
	},
	-- copilot
	{
		"zbirenbaum/copilot-cmp",
		event = { "BufReadPost", "BufNewFile" },
		config = function(_, opts)
			local copilot_cmp = require("copilot_cmp")
			copilot_cmp.setup(opts)
			require("utils").on_attach(function(client)
				if client.name == "copilot" then
					copilot_cmp._on_insert_enter()
				end
			end)
		end,
		dependencies = {
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			build = ":Copilot auth",
			opts = {
				suggestion = { enabled = false },
				panel = { enabled = false },
			},
		},
	},
	-- colorscheme
	{
		"echasnovski/mini.base16",
		event = { "VimEnter" },
		priority = 100,
		config = function()
			require("utils").set_theme()
		end,
	},
	-- Terminal
	{
		"NvChad/nvterm",
		lazy = true,
		config = true,
	},
	-- Misc
	{
		"lukas-reineke/indent-blankline.nvim",
		-- main = "ibl",
		version = "2.20.7",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugins").indent()
		end,
	},
	{
		dir = "~/.config/nvim/lua/mini",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugins").mini()
		end,
	},
}
---}}}

--{{{ Lazy
local lazy = require("lazy")
local opts = {
	rtp = {
		disabled_plugins = {
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
		},
	},
}
lazy.setup(plugins, opts)
---}}}

--{{{Global
require("options")
require("keymap")
--}}}
--{{{Autocommands
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
