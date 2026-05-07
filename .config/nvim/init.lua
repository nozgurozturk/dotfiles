-- Before anything;
local nvim_start_time = vim.uv.hrtime()

-- Experimental Lua module loader.
vim.loader.enable()

-- Define main config table to be able to pass data between scripts
_G.Config = {
  nvim_start_time = nvim_start_time,
  called = {},
  mason = {},
  treesitter = {},
  conform = {},
}

require('vim._core.ui2').enable { enable = true }
