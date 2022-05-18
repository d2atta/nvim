local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics

local sources = {
	completion.luasnip,
	diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
	formatting.black.with({ extra_args = { "--fast" } }),
	formatting.stylua,
	-- formatting.prettier.with({ extra_args = { "--no-semi", "--single" } }),
	-- formatting.rustfmt,
	-- formatting.clang_format,
	-- formatting.codespell,
}

null_ls.setup({
	debug = false,
	sources = sources,
	-- format on save
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
		end
	end,
})
