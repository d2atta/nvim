local M = {}

M.conform = function()
	local conform = require("conform")
	local opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			rust = { "rustfmt" },
			shell = { "shellcheck" },
			json = { "jq" },
			toml = { "taplo" },
			yaml = { "yamlfix" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_fallback = true,
		},
	}
	conform.setup(opts)
end

function M.lsp_icons()
	return {
		Namespace = "",
		Text = " ",
		Method = " ",
		Function = " ",
		Constructor = " ",
		Field = "ﰠ ",
		Variable = " ",
		Class = "ﴯ ",
		Interface = " ",
		Module = " ",
		Property = "ﰠ ",
		Unit = "塞 ",
		Value = " ",
		Enum = " ",
		Keyword = " ",
		Snippet = " ",
		Color = " ",
		File = " ",
		Reference = " ",
		Folder = " ",
		EnumMember = " ",
		Constant = " ",
		Struct = "פּ ",
		Event = " ",
		Operator = " ",
		TypeParameter = " ",
		Table = "",
		Object = " ",
		Tag = "",
		Array = "[]",
		Boolean = " ",
		Number = " ",
		Null = "ﳠ",
		String = " ",
		Calendar = "",
		Watch = " ",
		Package = "",
		Copilot = " ",
	}
end

M.lspconfig = function()
	local servers = { "pyright", "lua_ls", "rust_analyzer", "clangd" } --"html"
	local nmap = require("utils").nmap
	local on_attach = function(_, bufnr)
		-- Mappings.
		nmap({
			"<C-k>",
			function()
				vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
			end,
			{ buffer = bufnr },
		})
		nmap({ "gD", vim.lsp.buf.declaration, { buffer = bufnr } })
		nmap({ "gd", vim.lsp.buf.definition, { buffer = bufnr } })
		nmap({ "gi", vim.lsp.buf.implementation, { buffer = bufnr } })
		nmap({ "gr", vim.lsp.buf.references, { buffer = bufnr } })
		nmap({ "<space>D", vim.lsp.buf.type_definition, { buffer = bufnr } })
		nmap({ "<space>rn", vim.lsp.buf.rename, { buffer = bufnr } })
		nmap({ "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr } })

		vim.lsp.protocol.CompletionItemKind = M.lsp_icons()
		vim.opt.signcolumn = "auto:2"
	end

	-- Diagonistic
	local signs = { Error = "", Warn = "", Hint = "", Info = "" }

	vim.diagnostic.config({
		virtual_text = true,
		signs = false,
		underline = true,
		update_in_insert = true,
		severity_sort = false,
	})
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
	vim.o.updatetime = 250
	-- local augroup = vim.api.nvim_create_augroup("LspDiagonostic", {})
	-- vim.api.nvim_create_autocmd("CursorHold", {
	-- 	group = augroup,
	-- 	buffer = 0,
	-- 	callback = function()
	-- 		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	-- 	end,
	-- })

	for _, lsp in pairs(servers) do
		require("lspconfig")[lsp].setup({
			on_attach = on_attach,
		})
	end

	-- lua lsp
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/mini/?.lua")
	table.insert(runtime_path, "lua/plugins/?.lua")

	local lsp = require("lspconfig")
	lsp["lua_ls"].setup({
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = runtime_path,
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
end

return M
