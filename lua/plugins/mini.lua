local M = {}

M.mini_statusline = function()
	local section_location = function(args)
		if MiniStatusline.is_truncated(args.trunc_width) then
			return "[%2l/%2L]"
		else
			return "[%2l/%2L] %y"
		end
	end

	local get_icon = function(filetype)
		return (MiniIcons.get("filetype", filetype))
	end

	local get_filetype_icon = function()
		local filetype = vim.bo.filetype
		if filetype == "" then
			return ""
		end
		return (get_icon(filetype))
	end
	local active_content = function()
		local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 85 })
		local git = MiniStatusline.section_git({ trunc_width = 40 })
		local diag_signs = { ERROR = " ", WARN = " ", INFO = " ", HINT = " " }
		local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75, signs = diag_signs, icon = "" })
		local filename = MiniStatusline.section_filename({ trunc_width = 140 })
		local fileicon = get_filetype_icon()
		local location = section_location({ trunc_width = 75 })

		return MiniStatusline.combine_groups({
			{ hl = mode_hl, strings = { mode } },
			{ hl = "MiniStatuslineDevinfo", strings = { git } },
			"%=",
			{ hl = "MiniStatuslineFileinfo", strings = { fileicon, filename } },
			"%=", -- End left alignment
			{ hl = "MiniStatuslineDevinfo", strings = { diagnostics, location } },
		})
	end
	require("mini.statusline").setup({
		content = { active = active_content, inactive = nil },
	})
end

M.mini_hipatterns = function()
	local hipatterns = require("mini.hipatterns")
	hipatterns.setup({
		highlighters = {
			-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

			-- Highlight hex color strings (`#rrggbb`) using that color
			hex_color = hipatterns.gen_highlighter.hex_color(),
		},
	})
end

return M
