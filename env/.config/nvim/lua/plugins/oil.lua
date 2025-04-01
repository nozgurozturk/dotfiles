return {
  'stevearc/oil.nvim',
  config = function()
    local oil = require 'oil'
    oil.setup {
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        -- 'icon',
        -- "permissions",
        -- "size",
        -- "mtime",
      },
    }

    local map = function(mode, keys, func, desc)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { desc = 'Ex: ' .. desc })
    end

    map('n', '-', '<CMD>Oil<CR>', 'Open parent directory')
  end,
}
