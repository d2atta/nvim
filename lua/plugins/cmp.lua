local present, cmp = pcall(require, "blink.cmp")

if not present then
	return
end
cmp.setup({
	-- sources = {
	-- 	default = { "lsp", "path", "buffer" },
	-- },
	-- keymap = {
	-- 	["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
	-- 	["<C-e>"] = { "hide" },
	-- 	["<CR>"] = { "accept", "fallback" },
	--
	-- 	["<S-Tab>"] = { "select_prev", "fallback" },
	-- 	["<Tab>"] = { "select_next", "fallback" },
	--
	-- 	["<C-b>"] = { "scroll_documentation_up", "fallback" },
	-- 	["<C-f>"] = { "scroll_documentation_down", "fallback" },
	-- },
	-- keymap = { preset = "default" },
	signature = { enabled = true },
	completion = {
		menu = {
			auto_show = function(ctx)
				return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
			end,
		},
		ghost_text = {
			enabled = false,
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
		},
	},
})
