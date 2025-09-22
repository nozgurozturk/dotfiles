return {
  'catppuccin/nvim',
  lazy = false,
  priority = 1000,
  init = function()
    require('catppuccin').setup {
      integrations = {
        diffview = true,
        mason = true,
        telekasten = true,
        which_key = true,
      },
    }
    vim.cmd 'colorscheme catppuccin'
  end,
}
