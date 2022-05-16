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
      print "Error: Provide current and new theme name"
      return false
   end
   if current_theme == new_theme then
      return
   end

   local file = vim.fn.stdpath "config" .. "/lua/plugins/" .. "mini.lua"

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

M.setup = function(opts)
   local pickers, finders, actions, action_state, conf
   if pcall(require, "telescope") then
      pickers = require "telescope.pickers"
      finders = require "telescope.finders"
      actions = require "telescope.actions"
      action_state = require "telescope.actions.state"
      conf = require("telescope.config").values
   else
      error "Cannot find telescope!"
   end

   -- get a table of available themes
   local themes = {
	"aquarium","blossom","catppuccin",
	"chadracula","chadtain","classic-dark",
	"doom-chad","everforest","gruvbox",
	"gruvchad","javacafe","jellybeans",
	"monekai","monokai","mountain",
	"nightlamp","nightowl","nord",
	"onedark","onedark-deep","onejelly",
	"one-light","onenord","palenight",
	"paradise","penokai","solarized",
	"tokyodark","tokyonight","tomorrownight",
	"uwu","lfgruv","mini-scheme",
	"spacemacs","pop",
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
      end

      pickers.new({
         prompt_title = "Set Colorscheme",
         finder = finders.new_table(themes),
         previewer = nil,
         sorter = conf.generic_sorter(opts),
         attach_mappings = function()
            actions.select_default:replace(
               -- if a entry is selected, change current_theme to that
               function(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  new_theme = selection.value
		  change = true
		  Set_theme(new_theme)
		  close_windows()
                  actions.close(prompt_bufnr)
               end
            )
            return true
         end,
      }):find()

   end
end

return M
