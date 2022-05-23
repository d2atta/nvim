local M = {}

M.telescope = function()
	local present, tl_config = pcall(require, "telescope")
	if not present then
		return
	end

	local default = {
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			prompt_prefix = "   ",
			selection_caret = "  ",
			entry_prefix = "  ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
			path_display = { "truncate" },
			winblend = 0,
			border = {},
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			color_devicons = false,
			use_less = true,
			set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			-- Developer configurations: Not meant for general override
			buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		},
	}
	tl_config.setup(default)
end

M.treesitter = function()
	local present, ts_config = pcall(require, "nvim-treesitter.configs")
	if not present then
		return
	end

	local default = {
		ensure_installed = {
			"lua",
			"python",
			"bash",
			"vim",
		},
		indent = {
			enable = true,
		},
	}
	ts_config.setup(default)
end

M.nvimtree = function()
	local present, nvtree = pcall(require, "nvim-tree")
	if not present then
		return
	end

	-- globals must be set prior to requiring nvim-tree to function
	local g = vim.g
	g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
	g.nvim_tree_highlight_opened_files = 0
	g.nvim_tree_show_icons = {
		folders = 1,
		files = 1,
		git = 1,
		folder_arrows = 1,
	}
	g.nvim_tree_icons = {
		default = "",
		symlink = "",
		git = {
			deleted = "",
			ignored = "◌",
			renamed = "➜",
			staged = "✓",
			unmerged = "",
			unstaged = "",
			untracked = "?",
		},
	}

	local options = {
		filters = {
			dotfiles = false,
			exclude = { "custom" },
		},
		disable_netrw = true,
		hijack_netrw = true,
		open_on_tab = false,
		hijack_cursor = true,
		hijack_unnamed_buffer_when_opening = false,
		update_cwd = true,
		update_focused_file = {
			enable = true,
			update_cwd = true,
		},
		view = {
			side = "right",
			width = 25,
			hide_root_folder = false,
		},
		git = {
			enable = true,
			ignore = true,
		},
		actions = {
			open_file = {
				resize_window = true,
			},
		},
		renderer = {
			indent_markers = {
				enable = false,
			},
		},
	}
	nvtree.setup(options)
end

M.Luasnip = function()
	local present, ls = pcall(require, "luasnip")
	if not present then
		return
	end
	-- local map = require("plugins.keymap").map
	ls.config.set_config({
		history = true,
		updateevents = "TextChanged, TextChangedI",
	})
	vim.keymap.set({ "i", "s" }, "<c-k>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end)
	require("luasnip.loaders.from_snipmate").lazy_load()
end

M.mini = function()
	require("utils").set_theme()
	require("mini.tabline").setup()
	require("mini.statusline").setup()
	require("mini.comment").setup()
	require("mini.completion").setup({ delay = { completion = 100, info = 10, signature = 50 } })
	require("mini.pairs").setup()
	require("mini.surround").setup()
end

return M
