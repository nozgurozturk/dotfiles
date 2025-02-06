return {
  'stevearc/oil.nvim',
  config = function()
    local oil = require 'oil'
    oil.setup {
      view_options = {
        show_hidden = true,
      },
      columns = {},
    }

    local map = function(mode, keys, func, desc)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { desc = 'Ex: ' .. desc })
    end

    map('n', '-', '<CMD>Oil<CR>', 'Open parent directory')
  end,
}
