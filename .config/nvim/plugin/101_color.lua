vim.pack.add { 'https://github.com/oskarnurm/koda.nvim' }

require('koda').setup {
  theme = {
    dark = 'moss',
    light = 'glade',
  },
}

vim.cmd 'colorscheme koda'
