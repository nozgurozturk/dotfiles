return {
  'nvim-mini/mini.pick',
  dependencies = { 'nvim-mini/mini.extra' },
  version = '*',
  config = function()
    require('mini.extra').setup()

    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)

    require('mini.pick').setup {
      options = {
        use_cache = true,
      },
      window = {
        config = {
          border = 'single',
          anchor = 'NW',
          height = height,
          width = width,
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
        },
      },
      mappings = {
        toggle_info = '<C-k>',
        toggle_preview = '<C-P>',
      },
    }
  end,
}
