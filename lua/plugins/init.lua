local M = {}

M.telescope = function()
	local present, tl_config = pcall(require, "telescope")
	if not present then
		return
	end

	local default = {
		playground = {
			enable = true,
		},
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
			generic_sorter = require("mini.fuzzy").get_telescope_sorter,
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
			mappings = {
				n = { ["q"] = require("telescope.actions").close },
			},
		},
		pickers = {
			find_files = {
				theme = "dropdown",
			},
			buffers = {
				theme = "dropdown",
				previewer = false,
			},
		},
		extensions_list = { "file_browser" },
		extensions = {
			file_browser = {
				dir_icon = "",
				display_stat = { date = false, size = true, mode = true },
				hijack_netrw = true,
				theme = "ivy",
			},
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
		highlight = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
		ensure_installed = {
			"lua",
			"python",
			"cpp",
			"go",
			"html",
			"rust",
			"bash",
			"vim",
			"org",
		},
		indent = {
			enable = true,
			-- disable = { "python" },
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
		},
	}
	ts_config.setup(default)
end

M.twilight = function()
	local present, tw_config = pcall(require, "twilight")
	if not present then
		return
	end

	tw_config.setup({
		dimming = {
			alpha = 0.25, -- amount of dimming
			-- we try to get the foreground from the highlight groups or fallback color
			color = { "Normal", "#ffffff" },
			term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
			inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
		},
		context = 10, -- amount of lines we will try to show around the current line
		treesitter = true, -- use treesitter when available for the filetype
		-- treesitter is used to automatically expand the visible text,
		-- but you can further control the types of nodes that should always be fully expanded
		expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
			"function",
			"method",
			"table",
			"if_statement",
		},
		exclude = {}, -- exclude these filetypes
	})
end

M.indent = function()
	local present, indent = pcall(require, "ibl")
	if not present then
		return
	end
	local opts = {
		exclude = {
			filetypes = { "lazy", "lspinfo" },
		},
		whitespace = { highlight = { "Whitespace", "NonText" } },
	}
	indent.setup(opts)
end

M.oil = function()
	local present, oil_conf = pcall(require, "oil")
	if not present then
		return
	end
	local options = {
		float = {
			padding = 2,
			max_width = 70,
			max_height = 20,
			border = "rounded",
		},
		win_options = {
			winblend = 2,
		},
		use_default_keymaps = false,
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-h>"] = "actions.select_split",
			["<C-c>"] = "actions.close",
			["<C-l>"] = "actions.refresh",
			["<C-p>"] = "actions.parent",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
		},
	}
	oil_conf.setup(options)
end

M.Luasnip = function()
	local present, ls = pcall(require, "luasnip")
	if not present then
		return
	end
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

return M
