return {
  {
    'stevearc/oil.nvim',
    config = function()
      local oil = require 'oil'
      oil.setup {
        default_file_explorer = true,
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, bufnr)
            local m = name:match '^.*.meta$'
            return m ~= nil or name == '.git'
          end,
        },
        win_options = {
          wrap = true,
          signcolumn = 'yes:2',
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
  },
  {
    'refractalize/oil-git-status.nvim',
    dependencies = { 'stevearc/oil.nvim' },
    config = true,
  },
}
