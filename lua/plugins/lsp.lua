local M = {}

M.nullLs = function()
	local null_ls = require("null-ls")
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics

	local sources = {
		diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.rustfmt,
		formatting.clang_format,
		-- completion.luasnip,
		-- formatting.prettier.with({ extra_args = { "--no-semi", "--single" } }),
		-- formatting.codespell,
	}
	local lsp_formatting = function(bufnr)
		vim.lsp.buf.format({
			filter = function(clients)
				-- filter out clients that you don't want to use
				return vim.tbl_filter(function(client)
					return client.name ~= "rust_analyzer"
				end, clients)
			end,
			bufnr = bufnr,
		})
	end

	-- if you want to set up formatting on save, you can use this as a callback
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	null_ls.setup({
		debug = false,
		sources = sources,
		-- format on save
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						lsp_formatting(bufnr)
					end,
				})
			end
		end,
	})
end

M.lspconfig = function()
	local servers = { "pyright", "sumneko_lua", "rust_analyzer", "html", "clangd" }
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

		vim.lsp.protocol.CompletionItemKind = require("mini.icons").lsp_icons()
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
			flags = {
				debounce_text_changes = 150,
			},
		})
	end

	-- lua lsp
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/mini/?.lua")
	table.insert(runtime_path, "lua/plugins/?.lua")

	local lsp = require("lspconfig")
	lsp["sumneko_lua"].setup({
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
