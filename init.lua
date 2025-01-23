---------------------------------------------------------------------------
--                             N V I M
---------------------------------------------------------------------------
-- Install lazy.vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable", -- latest stable release
		lazyrepo,
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- Theme & leader
vim.g.theme = "doom-chad"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Package manager
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
	-- Mini express
	{
		"echasnovski/mini.nvim",
		event = { "BufReadPost" },
		config = function()
			-- Icons
			require("mini.icons").setup()

			-- colorscheme
			require("utils").set_theme()
			require("plugins.mini").mini_hipatterns()

			-- Tabline
			require("mini.tabline").setup()

			-- statusline
			require("plugins.mini").mini_statusline()

			-- Indentscope
			require("mini.indentscope").setup()

			-- Git
			require("mini.diff").setup()
			require("mini.git").setup()

			-- Editing
			-- require("mini.bufremove").setup()
			require("mini.bracketed").setup()
			require("mini.pairs").setup()
			require("mini.trailspace").setup()

			-- Telescope
			require("mini.fuzzy").setup()

			-- Notification
			require("mini.notify").setup()
		end,
	},
	-- Find files
	{
		"nvim-telescope/telescope.nvim",
		event = "BufReadPost",
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			require("plugins").telescope()
		end,
	},
	-- lsp
	{
		"neovim/nvim-lspconfig",
		module = "lspconfig",
		ft = { "python", "lua", "sh", "cpp", "markdown", "rust", "astro", "typescriptreact" },
		event = "User FilePost",
		config = function()
			require("plugins.lsp").lspconfig()
		end,
		dependencies = {
			{
				"saghen/blink.cmp",
				lazy = false, -- lazy loading handled internally
				version = "v0.*",
				config = function()
					require("plugins.cmp")
				end,
			},
			{
				"stevearc/conform.nvim",
				event = { "User FilePost" },
				cmd = { "ConformInfo" },
				config = function()
					require("plugins.lsp").conform()
				end,
			},
		},
	},
	-- Terminal
	{ "NvChad/nvterm", config = true },
}

-- Lazy
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

-- Global
require("options")
require("keymap")

-- Autocommands
-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
vim.api.nvim_create_autocmd("LspNotify", {
	callback = function(args)
		if args.data.method == "textDocument/didOpen" then
			vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
		end
	end,
})
-- Fixes for floating windows
vim.api.nvim_set_hl(0, "FloatBorder", { link = "NormalFloat" })
