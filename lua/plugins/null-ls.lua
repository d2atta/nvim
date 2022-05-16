local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
   -- Shell
   b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
   b.formatting.prettier.with { filetypes = { "json", "yaml", "markdown"}},
   b.formatting.black,
   -- b.formatting.rustfmt,
   -- b.formatting.clang_format,
   -- b.formatting.codespell,
}

null_ls.setup {
debug = true,
sources = sources,
-- format on save
on_attach = function(client)
 if client.resolved_capabilities.document_formatting then
    vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
 end
end,
}
