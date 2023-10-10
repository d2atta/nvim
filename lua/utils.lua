local M = {}

---@param on_attach fun(client, buffer)
M.on_attach = function(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end
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

-- Function to extract base name
local function processFileName(fileName)
	local baseName = fileName:match("^(.-)-base16%.lua")
	if baseName then
		return baseName
	end
	return nil
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
	local themes = {}
	-- Get list of files in the directory
	local files = io.popen('ls "$HOME/.config/nvim/lua/themes/"'):lines()

	-- Process each file
	for fileName in files do
		local newName = processFileName(fileName)
		if newName then
			table.insert(themes, newName)
		end
	end

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

		pickers
			.new({
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
			})
			:find()
	end
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
		use_cterm = false,
	})
end

-- Get functions in current file
local python_function_query_string = [[
  (function_definition 
    name: (identifier) @func_name (#offset! @func_name)
  ) 
]]

local lua_function_query_string = [[
  (function_declaration
  name:
    [
      (dot_index_expression)
      (identifier)
    ] @func_name (#offset! @func_name)
  )
]]

local func_lookup = {
	python = python_function_query_string,
	lua = lua_function_query_string,
}

local function get_functions(bufnr, lang, query_string)
	local parser = vim.treesitter.get_parser(bufnr, lang)
	local syntax_tree = parser:parse()[1]
	local root = syntax_tree:root()
	local query = vim.treesitter.query.parse(lang, query_string)
	local func_list = {}

	for _, captures, metadata in query:iter_matches(root, bufnr) do
		local row, col, _ = captures[1]:start()
		local name = vim.treesitter.get_node_text(captures[1], bufnr)
		table.insert(func_list, { name, row, col, metadata[1].range })
	end
	return func_list
end

function M.goto_function(bufnr, lang)
	local pickers, finders, actions, action_state, conf
	if pcall(require, "telescope") then
		pickers = require("telescope.pickers")
		finders = require("telescope.finders")
		actions = require("telescope.actions")
		action_state = require("telescope.actions.state")
		conf = require("telescope.config").values
	else
		error("Cannot find telescope!")
	end

	bufnr = bufnr or vim.api.nvim_get_current_buf()
	lang = lang or vim.api.nvim_buf_get_option(bufnr, "filetype")

	local query_string = func_lookup[lang]
	if not query_string then
		vim.notify(lang .. " is not supported", vim.log.levels.INFO)
		return
	end
	local func_list = get_functions(bufnr, lang, query_string)
	if vim.tbl_isempty(func_list) then
		vim.notify("No functions found in current file", vim.log.levels.INFO)
		return
	end
	local funcs = {}
	for _, func in ipairs(func_list) do
		table.insert(funcs, func[1])
	end

	pickers
		.new(opts, {
			prompt_title = "Function List",
			finder = finders.new_table({
				results = func_list,
				entry_maker = function(entry)
					return { value = entry, display = entry[1], ordinal = entry[1] }
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function()
				actions.select_default:replace(function(prompt_bufnr)
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local row, col = selection.value[2] + 1, selection.value[3] + 2
					vim.fn.setcharpos(".", { bufnr, row, col, 0 })
				end)
				return true
			end,
		})
		:find()
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

M.tmap = function(tbl)
	if tbl[3] then
		for k, v in ipairs(tbl[3]) do
			opts[k] = v
		end
	end
	vim.keymap.set("t", tbl[1], tbl[2], opts)
end

M.vmap = function(tbl)
	if tbl[3] then
		for k, v in ipairs(tbl[3]) do
			opts[k] = v
		end
	end
	vim.keymap.set("v", tbl[1], tbl[2], opts)
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
