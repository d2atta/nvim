-- LSP
-- Write the servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = { "pyright", "sumneko_lua", "rust_analyzer", "html" }
local on_attach = function(client, bufnr)
	-- Mappings.
	vim.api.nvim_buf_set_keymap(
		0,
		"n",
		"gD",
		"<Cmd>lua vim.lsp.buf.declaration()<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		0,
		"n",
		"gd",
		"<Cmd>lua vim.lsp.buf.definition()<CR>",
		{ noremap = true, silent = true }
	)
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
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]])

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

require("lspconfig")["sumneko_lua"].setup({
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
