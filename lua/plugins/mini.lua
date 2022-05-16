------------------------------------------------------------------------------
--                               UI
------------------------------------------------------------------------------
--{{{ Theme
-- Themes available (pywal also)
-- ----------------------------------------
-- |aquarium  |blossom     |catppuccin    |
-- |chadracula|chadtain    |classic-dark  |
-- |doom-chad |everforest  |gruvbox       |
-- |gruvchad  |javacafe    |jellybeans    |
-- |monekai   |monokai     |mountain      |
-- |nightlamp |night-owl   |nord          |
-- |onedark   |onedark-deep|onejelly      |
-- |one-light |onenord     |palenight     |
-- |paradise  |penokai     |solarized     |
-- |tokyodark |tokyonight  |tomorrow-night|
-- |uwu       |lfgruv      |mini-scheme   |
-- |spacemacs |pop         |              |
-- ----------------------------------------
function Set_theme(theme)
  local file
  if not theme then
    vim.g.theme = "monekai"
    file = "themes/".. vim.g.theme .."-base16"
  else
    file = "themes/".. theme .. "-base16"
  end
  local pallate = require(file)
  require('mini.base16').setup({
	palette = pallate,
	use_cterm = true,
  })
end
Set_theme()

--}}}

require('mini.tabline').setup()
require('mini.statusline').setup()
------------------------------------------------------------------------------
--                               C O D E
------------------------------------------------------------------------------
require('mini.comment').setup()
require('mini.completion').setup({
	delay = {completion = 100, info = 10, signature = 50 }
})
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.indentscope').setup()

