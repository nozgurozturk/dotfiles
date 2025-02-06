return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local function map(mode, keys, func, desc)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { desc = 'Ex: ' .. desc })
    end

    local harpoon = require 'harpoon'
    harpoon:setup()

    map('n', '<leader>a', function()
      harpoon:list():add()
    end, '[a]dd file to harpoon')
    map('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, '[e]xplore harpoon')
  end,
}
