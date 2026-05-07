vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/refractalize/oil-git-status.nvim',
}

require('oil').setup {
  default_file_explorer = true,
  view_options = {
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
  columns = {},
}

require('oil-git-status').setup()
