local present, cmp = pcall(require, "blink.cmp")

if not present then
	return
end
cmp.setup({
	sources = {
		completion = {
			enabled_providers = { "lsp", "path", "buffer", "lua" },
		},
	},
	-- windows = {
	--         ghost_text = { enabled = true },
	-- },
	keymap = {
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },
		["<CR>"] = { "accept", "fallback" },

		["<S-Tab>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },

		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
	},
	highlight = {
		use_nvim_cmp_as_default = true,
	},
	nerd_font_variant = "normal",
	trigger = { signature_help = { enabled = true } },
})

-- local present, cmp = pcall(require, "cmp")
--
-- if not present then
-- 	return
-- end
--
-- vim.o.completeopt = "menu,menuone,noselect"
--
-- local function border(hl_name)
-- 	return {
-- 		{ "╭", hl_name },
-- 		{ "─", hl_name },
-- 		{ "╮", hl_name },
-- 		{ "│", hl_name },
-- 		{ "╯", hl_name },
-- 		{ "─", hl_name },
-- 		{ "╰", hl_name },
-- 		{ "│", hl_name },
-- 	}
-- end
--
-- local cmp_window = require("cmp.utils.window")
--
-- cmp_window.info_ = cmp_window.info
-- cmp_window.info = function(self)
-- 	local info = self:info_()
-- 	info.scrollable = false
-- 	return info
-- end
--
-- local options = {
-- 	window = {
-- 		completion = {
-- 			border = border("CmpBorder"),
-- 			winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
-- 		},
-- 		documentation = {
-- 			border = border("CmpDocBorder"),
-- 		},
-- 	},
-- 	formatting = {
-- 		format = function(_, vim_item)
-- 			local icons = require("plugins.lsp").lsp_icons()
-- 			vim_item.kind = string.format("%s", icons[vim_item.kind])
-- 			return vim_item
-- 		end,
-- 	},
-- 	mapping = {
-- 		["<C-p>"] = cmp.mapping.select_prev_item(),
-- 		["<C-n>"] = cmp.mapping.select_next_item(),
-- 		["<C-d>"] = cmp.mapping.scroll_docs(-4),
-- 		["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 		["<C-Space>"] = cmp.mapping.complete(),
-- 		["<C-e>"] = cmp.mapping.close(),
-- 		["<CR>"] = cmp.mapping.confirm({
-- 			select = false,
-- 			behavior = cmp.ConfirmBehavior.Replace,
-- 		}),
-- 		["<Tab>"] = cmp.mapping(function(fallback)
-- 			if cmp.visible() then
-- 				cmp.select_next_item()
-- 			else
-- 				fallback()
-- 			end
-- 		end, {
-- 			"i",
-- 			"s",
-- 		}),
-- 		["<S-Tab>"] = cmp.mapping(function(fallback)
-- 			if cmp.visible() then
-- 				cmp.select_prev_item()
-- 			else
-- 				fallback()
-- 			end
-- 		end, {
-- 			"i",
-- 			"s",
-- 		}),
-- 	},
-- 	sources = {
-- 		{ name = "nvim_lsp" },
-- 		{ name = "buffer" },
-- 		{ name = "nvim_lua" },
-- 		{ name = "path" },
-- 		{
-- 			name = "spell",
-- 			option = {
-- 				keep_all_entries = false,
-- 				enable_in_context = function()
-- 					return true
-- 				end,
-- 			},
-- 		},
-- 	},
-- 	sorting = {
-- 		priority_weight = 2,
-- 		comparators = {
-- 			cmp.config.compare.offset,
-- 			cmp.config.compare.exact,
-- 			cmp.config.compare.score,
-- 			cmp.config.compare.recently_used,
-- 			cmp.config.compare.locality,
-- 			cmp.config.compare.kind,
-- 			cmp.config.compare.sort_text,
-- 			cmp.config.compare.length,
-- 			cmp.config.compare.order,
-- 		},
-- 	},
-- }
-- cmp.setup(options)
