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
	-- colorscheme
	{
		"echasnovski/mini.base16",
		event = { "VimEnter" },
		priority = 100,
		config = function()
			require("utils").set_theme()
		end,
	},
	-- Tabline
	{ "echasnovski/mini.tabline", event = { "VimEnter" }, config = true },
	-- statusline
	{
		"echasnovski/mini.statusline",
		event = { "VimEnter" },
		config = function()
			require("plugins").mini_statusline()
		end,
	},
	-- code highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugins").treesitter()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost" },
		config = function()
			require("plugins").indent()
		end,
	},
	-- Icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	-- Find files
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("fzf") == 1
				end,
			},
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
			{ "j-hui/fidget.nvim", opts = {} },
			{
				"saghen/blink.cmp",
				lazy = false, -- lazy loading handled internally
				version = "v0.*",
				dependencies = {
					"saghen/blink.compat",
					"hrsh7th/cmp-nvim-lua",
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-buffer",
					"hrsh7th/cmp-path",
				},
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
	-- git
	{ "echasnovski/mini.diff", event = "BufReadPost", config = true },
	{ "echasnovski/mini-git", event = "BufReadPost", config = true, main = "mini.git" },
	-- pairs
	{ "echasnovski/mini.pairs", event = { "BufReadPost" }, config = true },
	-- Terminal
	{ "NvChad/nvterm", config = true },
	-- AI
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false,
		build = "make",
		opts = {
			provider = "ollama",
			vendors = {
				ollama = {
					api_key_name = "",
					endpoint = "127.0.0.1:11434/v1",
					model = "smollm2:latest",
					parse_curl_args = function(opts, code_opts)
						return {
							url = opts.endpoint .. "/chat/completions",
							headers = {
								["Accept"] = "application/json",
								["Content-Type"] = "application/json",
							},
							body = {
								model = opts.model,
								messages = require("avante.providers").copilot.parse_messages(code_opts),
								max_tokens = 2048,
								stream = true,
							},
						}
					end,
					parse_response_data = function(data_stream, event_state, opts)
						require("avante.providers").copilot.parse_response(data_stream, event_state, opts)
					end,
				},
			},
		},
		dependencies = {

			"stevearc/dressing.nvim",
			"MunifTanjim/nui.nvim",
			{
				"OXY2DEV/markview.nvim",
				enabled = true,
				lazy = false,
				ft = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
				opts = {
					filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
					buf_ignore = {},
					max_length = 99999,
				},
			},
		},
	},
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
