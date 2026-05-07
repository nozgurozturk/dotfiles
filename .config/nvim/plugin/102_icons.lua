vim.pack.add { 'https://github.com/nvim-mini/mini.icons' }

require('mini.icons').setup()

local lazy = require 'lazyload'

lazy.on_vim_enter(function()
  MiniIcons.mock_nvim_web_devicons()
  MiniIcons.tweak_lsp_kind()
end)
