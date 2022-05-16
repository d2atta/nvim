local Pairs = {}
local H = {}

function Pairs.setup(config)
  -- Export module
  _G.Pairs = Pairs

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)

  -- Module behavior
  vim.api.nvim_exec(
    [[augroup Pairs
        au!
        au FileType TelescopePrompt let b:minipairs_disable=v:true
        au FileType fzf let b:minipairs_disable=v:true
      augroup END]],
    false
  )
end

-- Module config --
Pairs.config = {
  -- In which modes mappings from this `config` should be created
  modes = { insert = true, command = false, terminal = false },

  mappings = {
    ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
    ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
    ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

    [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
    [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
    ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

    ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
    ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
    ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
  },
}

function Pairs.map(mode, lhs, pair_info, opts)
  pair_info = H.ensure_pair_info(pair_info)
  opts = vim.tbl_deep_extend('force', opts or {}, { expr = true, noremap = true })
  vim.api.nvim_set_keymap(mode, lhs, H.pair_info_to_map_rhs(pair_info), opts)
  H.register_pair(pair_info, mode, 'all')
end

function Pairs.map_buf(buffer, mode, lhs, pair_info, opts)
  pair_info = H.ensure_pair_info(pair_info)
  opts = vim.tbl_deep_extend('force', opts or {}, { expr = true, noremap = true })
  vim.api.nvim_buf_set_keymap(buffer, mode, lhs, H.pair_info_to_map_rhs(pair_info), opts)
  H.register_pair(pair_info, mode, buffer == 0 and vim.api.nvim_get_current_buf() or buffer)
end

function Pairs.unmap(mode, lhs, pair)
  vim.api.nvim_del_keymap(mode, lhs)
  if pair == nil then
    vim.notify([[(mini.pairs) Supply `pair` argument to `Pairs.unmap`.]])
  end
  if (pair or '') ~= '' then
    H.unregister_pair(pair, mode, 'all')
  end
end

function Pairs.unmap_buf(buffer, mode, lhs, pair)
  vim.api.nvim_buf_del_keymap(buffer, mode, lhs)
  if pair == nil then
    vim.notify([[(mini.pairs) Supply `pair` argument to `Pairs.unmap_buf`.]])
  end
  if (pair or '') ~= '' then
    H.unregister_pair(pair, mode, buffer == 0 and vim.api.nvim_get_current_buf() or buffer)
  end
end

function Pairs.open(pair, neigh_pattern)
  if H.is_disabled() or not H.neigh_match(neigh_pattern) then
    return pair:sub(1, 1)
  end

  return ('%s%s'):format(pair, H.get_arrow_key('left'))
end

function Pairs.close(pair, neigh_pattern)
  if H.is_disabled() or not H.neigh_match(neigh_pattern) then
    return pair:sub(2, 2)
  end

  local close = pair:sub(2, 2)
  if H.get_cursor_neigh(1, 1) == close then
    return H.get_arrow_key('right')
  else
    return close
  end
end

function Pairs.closeopen(pair, neigh_pattern)
  if H.is_disabled() or not (H.get_cursor_neigh(1, 1) == pair:sub(2, 2)) then
    return Pairs.open(pair, neigh_pattern)
  else
    return H.get_arrow_key('right')
  end
end

function Pairs.bs(pair_set)
  -- TODO: remove `pair_set` argument
  if pair_set ~= nil and not H.showed_deprecation then
    vim.notify(table.concat({
      '(mini.pairs)',
      [[`pair_set` arugment in both `Pairs.bs()` and `Pairs.cr()` is soft deprecated.]],
      [[It is no longer needed due to the mechanism of pairs registration inside new mapping functions.]],
      [[See `:h Pairs.map()` and `:h Pairs.map_buf()`.]],
      [[It will be removed in the future. Sorry for this.]],
    }, ' '))
    H.showed_deprecation = true
  end

  local res = H.keys.bs

  local neigh = H.get_cursor_neigh(0, 1)
  if not H.is_disabled() and H.is_pair_registered(neigh, vim.fn.mode(), 0, 'bs') then
    res = ('%s%s'):format(res, H.keys.del)
  end

  return res
end

function Pairs.cr(pair_set)
  -- TODO: remove `pair_set` argument
  if pair_set ~= nil and not H.showed_deprecation then
    vim.notify(table.concat({
      '(mini.pairs)',
      [[`pair_set` arugment in both `Pairs.bs()` and `Pairs.cr()` is soft deprecated.]],
      [[It is no longer needed due to the mechanism of pairs registration inside new mapping functions.]],
      [[See `:h Pairs.map()` and `:h Pairs.map_buf()`.]],
      [[It will be removed in the future. Sorry for this.]],
    }, ' '))
    H.showed_deprecation = true
  end

  local res = H.keys.cr

  local neigh = H.get_cursor_neigh(0, 1)
  if not H.is_disabled() and H.is_pair_registered(neigh, vim.fn.mode(), 0, 'cr') then
    res = ('%s%s'):format(res, H.keys.above)
  end

  return res
end

-- Helpers --
-- Module default config
H.default_config = Pairs.config

-- Default value of `pair_info` for mapping functions
H.default_pair_info = { neigh_pattern = '..', register = { bs = true, cr = true } }

-- Pair sets registered *per mode-buffer-key*. Buffer `'all'` contains pairs
-- registered for all buffers.
H.registered_pairs = {
  i = { all = { bs = {}, cr = {} } },
  c = { all = { bs = {}, cr = {} } },
  t = { all = { bs = {}, cr = {} } },
}

-- Deprecation indication. TODO: remove when there is not deprecation.
H.showed_deprecation = false

-- Precomputed keys to increase speed
-- stylua: ignore start
local function escape(s) return vim.api.nvim_replace_termcodes(s, true, true, true) end
H.keys = {
  above     = escape('<C-o>O'),
  bs        = escape('<bs>'),
  cr        = escape('<cr>'),
  del       = escape('<del>'),
  keep_undo = escape('<C-g>U'),
  -- NOTE: use `get_arrow_key()` instead of `H.keys.left` or `H.keys.right`
  left      = escape('<left>'),
  right     = escape('<right>')
}
-- stylua: ignore end

-- Settings
function H.setup_config(config)
  -- General idea: if some table elements are not present in user-supplied
  -- `config`, take them from default config
  vim.validate({ config = { config, 'table', true } })
  config = vim.tbl_deep_extend('force', H.default_config, config or {})

  vim.validate({
    modes = { config.modes, 'table' },
    ['modes.insert'] = { config.modes.insert, 'boolean' },
    ['modes.command'] = { config.modes.command, 'boolean' },
    ['modes.terminal'] = { config.modes.terminal, 'boolean' },

    mappings = { config.mappings, 'table' },
  })

  return config
end

function H.apply_config(config)
  Pairs.config = config

  -- Setup mappings in supplied modes
  local mode_ids = { insert = 'i', command = 'c', terminal = 't' }
  ---- Compute in which modes mapping should be set up
  local mode_array = {}
  for name, to_set in pairs(config.modes) do
    if to_set then
      table.insert(mode_array, mode_ids[name])
    end
  end

  for _, mode in pairs(mode_array) do
    for key, pair_info in pairs(config.mappings) do
      Pairs.map(mode, key, pair_info)
    end

    vim.api.nvim_set_keymap(mode, '<BS>', [[v:lua.Pairs.bs()]], { expr = true, noremap = true })
    if mode == 'i' then
      vim.api.nvim_set_keymap('i', '<CR>', [[v:lua.Pairs.cr()]], { expr = true, noremap = true })
    end
  end
end

function H.is_disabled()
  return vim.g.minipairs_disable == true or vim.b.minipairs_disable == true
end

-- Pair registration --
function H.register_pair(pair_info, mode, buffer)
  -- Process new mode
  H.registered_pairs[mode] = H.registered_pairs[mode] or { all = { bs = {}, cr = {} } }
  local mode_pairs = H.registered_pairs[mode]

  -- Process new buffer
  mode_pairs[buffer] = mode_pairs[buffer] or { bs = {}, cr = {} }

  -- Register pair if it is not already registered
  local register, pair = pair_info.register, pair_info.pair
  if register.bs and not vim.tbl_contains(mode_pairs[buffer].bs, pair) then
    table.insert(mode_pairs[buffer].bs, pair)
  end
  if register.cr and not vim.tbl_contains(mode_pairs[buffer].cr, pair) then
    table.insert(mode_pairs[buffer].cr, pair)
  end
end

function H.unregister_pair(pair, mode, buffer)
  local mode_pairs = H.registered_pairs[mode]
  if not (mode_pairs and mode_pairs[buffer]) then
    return
  end

  local buf_pairs = mode_pairs[buffer]
  for _, key in ipairs({ 'bs', 'cr' }) do
    for i, p in ipairs(buf_pairs[key]) do
      if p == pair then
        table.remove(buf_pairs[key], i)
        break
      end
    end
  end
end

function H.is_pair_registered(pair, mode, buffer, key)
  local mode_pairs = H.registered_pairs[mode]
  if not mode_pairs then
    return false
  end

  if vim.tbl_contains(mode_pairs['all'][key], pair) then
    return true
  end

  buffer = buffer == 0 and vim.api.nvim_get_current_buf() or buffer
  local buf_pairs = mode_pairs[buffer]
  if not buf_pairs then
    return false
  end

  return vim.tbl_contains(buf_pairs[key], pair)
end

-- Work with pair_info --
function H.ensure_pair_info(pair_info)
  vim.validate({ pair_info = { pair_info, 'table' } })
  pair_info = vim.tbl_deep_extend('force', H.default_pair_info, pair_info)

  vim.validate({
    action = { pair_info.action, 'string' },
    pair = { pair_info.pair, 'string' },
    neigh_pattern = { pair_info.neigh_pattern, 'string' },
    register = { pair_info.register, 'table' },
    ['register.bs'] = { pair_info.register.bs, 'boolean' },
    ['register.cr'] = { pair_info.register.cr, 'boolean' },
  })

  return pair_info
end

function H.pair_info_to_map_rhs(pair_info)
  return ('v:lua.Pairs.%s(%s, %s)'):format(
    pair_info.action,
    vim.inspect(pair_info.pair),
    vim.inspect(pair_info.neigh_pattern)
  )
end

-- Various helpers
function H.map(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { expr = true, noremap = true })
end

function H.get_cursor_neigh(start, finish)
  local line, col
  if vim.fn.mode() == 'c' then
    line = vim.fn.getcmdline()
    col = vim.fn.getcmdpos()
    -- Adjust start and finish because output of `getcmdpos()` starts counting
    -- columns from 1
    start = start - 1
    finish = finish - 1
  else
    line = vim.api.nvim_get_current_line()
    col = vim.api.nvim_win_get_cursor(0)[2]
  end

  -- Add '\r' and '\n' to always return 2 characters
  return string.sub(('%s%s%s'):format('\r', line, '\n'), col + 1 + start, col + 1 + finish)
end

function H.neigh_match(pattern)
  return (pattern == nil) or (H.get_cursor_neigh(0, 1):find(pattern) ~= nil)
end

function H.get_arrow_key(key)
  if vim.fn.mode() == 'i' then
    -- Using left/right keys in insert mode breaks undo sequence and, more
    -- importantly, dot-repeat. To avoid this, use 'i_CTRL-G_U' mapping.
    return H.keys.keep_undo .. H.keys[key]
  else
    return H.keys[key]
  end
end

return Pairs
