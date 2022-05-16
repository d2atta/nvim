local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
   return
end
local M = {}
local default = {
     ensure_installed = {
        "lua",
        "python",
        "bash",
        "vim",
     },
     sync_install = false,
     highlight = {
        enable = true,
        use_languagetree = true,
     },
     indent = {
        enable = true,
     },
}
M.setup = function()
	ts_config.setup(default)
end
return M

