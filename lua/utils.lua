local M = {}

M.file_fn = function(mode, filepath, content)
	local data
	local fd = assert(vim.loop.fs_open(filepath, mode, 438))
	local stat = assert(vim.loop.fs_fstat(fd))
	if stat.type ~= "file" then
		data = false
	else
		if mode == "r" then
			data = assert(vim.loop.fs_read(fd, stat.size, 0))
		else
			assert(vim.loop.fs_write(fd, content, 0))
			data = true
		end
	end
	assert(vim.loop.fs_close(fd))
	return data
end

M.change_config = function(current_theme, new_theme)
	if current_theme == nil or new_theme == nil then
		print("Error: Provide current and new theme name")
		return false
	end
	if current_theme == new_theme then
		return
	end

	local file = vim.fn.stdpath("config") .. "/init.lua"

	-- store in data variable
	local data = assert(M.file_fn("r", file))
	-- escape characters which can be parsed as magic chars
	current_theme = current_theme:gsub("%p", "%%%0")
	new_theme = new_theme:gsub("%p", "%%%0")
	local find = "vim.g.theme = .?" .. current_theme .. ".?"
	local replace = 'vim.g.theme = "' .. new_theme .. '"'
	local content = string.gsub(data, find, replace)
	-- see if the find string exists in file
	if content == data then
		print("Error: Cannot change default theme with " .. new_theme .. ", edit " .. file .. " manually")
		return false
	else
		assert(M.file_fn("w", file, content))
	end
end

-- Custom theme picker
-- Most of the code is copied from telescope colorscheme plugin.
M.change_theme = function(opts)
	local pickers, finders, actions, previewers, action_state, conf
	if pcall(require, "telescope") then
		pickers = require("telescope.pickers")
		finders = require("telescope.finders")
		actions = require("telescope.actions")
		previewers = require("telescope.previewers")
		action_state = require("telescope.actions.state")
		conf = require("telescope.config").values
	else
		error("Cannot find telescope!")
	end

	-- get a table of available themes
	local themes = {
		"aquarium",
		"blossom",
		"catppuccin",
		"chadracula",
		"chadtain",
		"classic-dark",
		"doom-chad",
		"everforest",
		"gruvbox",
		"gruvchad",
		"javacafe",
		"jellybeans",
		"monekai",
		"monokai",
		"mountain",
		"nightlamp",
		"nightowl",
		"nord",
		"onedark",
		"onedark-deep",
		"onejelly",
		"one-light",
		"onenord",
		"palenight",
		"paradise",
		"penokai",
		"pywal",
		"solarized",
		"tokyodark",
		"tokyonight",
		"uwu",
		"lfgruv",
		"mini-scheme",
		"spacemacs",
		"pop",
	}
	if next(themes) ~= nil then
		-- save this to use it for later to restore if theme not changed
		local current_theme = vim.g.theme
		local new_theme = ""
		local change = false

		-- rewrite picker.close_windows
		local close_windows = function()
			local final_theme
			if change then
				final_theme = new_theme
			else
				final_theme = current_theme
			end

			if change then
				local res = string.lower(vim.fn.input("Set " .. new_theme .. " as default theme ? [y/N] ")) == "y"
				if res then
					M.change_config(current_theme, final_theme)
				else
					print("\nColorscheme changed for current session.")
				end
			end
			M.set_theme(final_theme)
		end
		local bufnr = vim.api.nvim_get_current_buf()
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		local c_previewer = previewers.new_buffer_previewer({
			define_preview = function(self, entry)
				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
				local filetype = require("plenary.filetype").detect(bufname) or "diff"
				require("telescope.previewers.utils").highlighter(self.state.bufnr, filetype)
				M.set_theme(entry.value)
			end,
		})

		pickers.new({
			previewer = c_previewer,
			prompt_title = "Set Colorscheme",
			finder = finders.new_table(themes),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function()
				actions.select_default:replace(
					-- if a entry is selected, change current_theme to that
					function(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						new_theme = selection.value
						change = true
						M.set_theme(new_theme)
						close_windows()
						actions.close(prompt_bufnr)
					end
				)
				return true
			end,
		}):find()
	end
end

local opts = { noremap = true, silent = true }
M.imap = function(tbl)
	if tbl[3] then
		for k, v in ipairs(tbl[3]) do
			opts[k] = v
		end
	end
	vim.keymap.set("i", tbl[1], tbl[2], opts)
end
M.nmap = function(tbl)
	if tbl[3] then
		for k, v in ipairs(tbl[3]) do
			opts[k] = v
		end
	end
	vim.keymap.set("n", tbl[1], tbl[2], opts)
end

M.set_theme = function(theme)
	local file
	if not theme then
		file = "themes/" .. vim.g.theme .. "-base16"
	else
		file = "themes/" .. theme .. "-base16"
	end
	local pallate = require(file)
	require("mini.base16").setup({
		palette = pallate,
		use_cterm = true,
	})
end

M.execute = function()
	local config = {
		cmds = {
			markdown = "glow %",
			python = "python3 %",
			cpp = "./$fileBase",
			lua = "luafile %",
			vim = "source %",
		},
		ui = {
			-- bot|top|vert
			pos = "vert",
			size = 50,
		},
	}

	local cmd = config.cmds[vim.bo.filetype]
	cmd = cmd:gsub("%%", vim.fn.expand("%"))
	cmd = cmd:gsub("$fileBase", vim.fn.expand("%:r"))
	cmd = cmd:gsub("$filePath", vim.fn.expand("%:p"))
	cmd = cmd:gsub("$file", vim.fn.expand("%"))
	cmd = cmd:gsub("$dir", vim.fn.expand("%:p:h"))
	cmd = cmd:gsub(
		"$moduleName",
		vim.fn.substitute(
			vim.fn.substitute(vim.fn.fnamemodify(vim.fn.expand("%:r"), ":~:."), "/", ".", "g"),
			"\\",
			".",
			"g"
		)
	)

	vim.cmd("silent! make")
	if cmd ~= nil then
		if cmd ~= "" then
			vim.cmd(config.ui.pos .. " " .. config.ui.size .. "new | term " .. cmd)
		end
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_keymap(buf, "n", "q", "<C-\\><C-n>:bdelete!<CR>", { silent = true })
		vim.api.nvim_buf_set_option(buf, "filetype", "Execute")
		vim.wo.number = false
		vim.wo.relativenumber = false
	else
		vim.cmd("echohl ErrorMsg | echo 'Error: Invalid command' | echohl None")
	end
end

return M
