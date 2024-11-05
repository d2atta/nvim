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
			vim.keymap.set("n", "<leader>tc", require("utils").change_theme, { desc = "[T]heme [C]hange" })
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
		keys = {
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]eymaps" },
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [K]eymaps" },
			{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
			{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
			{ "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = '[S]earch Recent Files ("." for repeat)' },
			{ "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "[ ] Find existing buffers" },
			{
				"<leader>fb",
				"<cmd>Telescope file_browser<cr>",
				desc = "[F]ile [B]rowser",
			},
		},
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
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension("file_browser"))
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
				dependencies = {
					"saghen/blink.compat",
					"hrsh7th/cmp-nvim-lua",
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-buffer",
					"hrsh7th/cmp-path",
				},
				sources = {
					completion = {
						enabled_providers = { "lsp", "path", "buffer", "lua" },
					},
				},
				windows = {
					ghost_text = { enabled = true },
				},
				opts = {
					keymap = {
						["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
						["<C-e>"] = { "hide" },
						["<CR>"] = { "accept", "fallback" },

						["<S-Tab>"] = { "select_prev", "fallback" },
						["<Tab>"] = { "select_next", "fallback" },

						["<C-b>"] = { "scroll_documentation_up", "fallback" },
						["<C-f>"] = { "scroll_documentation_down", "fallback" },
					},
					highlight = {
						use_nvim_cmp_as_default = true,
					},
					nerd_font_variant = "normal",
					accept = { auto_brackets = { enabled = true } },
					trigger = { signature_help = { enabled = true } },
				},
			},
			{
				"stevearc/conform.nvim",
				event = { "User FilePost" },
				cmd = { "ConformInfo" },
				config = function()
					require("plugins.lsp").conform()
				end,
			},
			{ "j-hui/fidget.nvim", opts = {} },
		},
	},
	-- git
	{ "echasnovski/mini.diff", event = "BufReadPost", config = true },
	{ "echasnovski/mini-git", event = "BufReadPost", config = true, main = "mini.git" },
	-- pairs
	{ "echasnovski/mini.pairs", event = { "BufReadPost" } },
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
	-- Terminal
	{
		"NvChad/nvterm",
		keys = {
			{
				"<leader>tt",
				function()
					require("nvterm.terminal").toggle("float")
				end,
				desc = "",
			},
		},
		config = true,
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
-- Fixes for floating windows
vim.api.nvim_set_hl(0, "FloatBorder", { link = "NormalFloat" })

--[[
{
       "stevearc/oil.nvim",
       config = function()
               require("plugins").oil()
       end,
},
-- lsp quickfix
{
	"folke/trouble.nvim",
	branch = "dev",
	after = "lspconfig",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
},
{
	"folke/twilight.nvim",
	cmd = "Twilight",
	opts = {
		dimming = {
			alpha = 0.25,
			color = { "Normal", "#ffffff" },
			term_bg = "#000000",
			inactive = false,
		},
	},
},
-- Journal
{
	"nvim-neorg/neorg",
	run = ":Neorg sync-parsers",
	cmd = "Neorg",
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {
					config = {
						icons = {
							todo = {
								cancelled = { icon = "" },
								done = { icon = "" },
								on_hold = { icon = "" },
								pending = { icon = "" },
								recurring = { icon = "" },
								uncertain = { icon = "" },
								undone = { icon = "" },
								urgent = { icon = "" },
							},
						},
					},
				},
				["core.integrations.treesitter"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/proj/mtech",
						},
						default_workspace = "notes",
					},
				},
			},
		})
	end,
},
]]
