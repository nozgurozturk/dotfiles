local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    { import = 'plugins' },
    { import = 'langs' },
  },
  defaults = {
    lazy = false, -- whether to lazy load all plugins by default
    version = false, -- always use the latest git commit
  },
  checker = { enabled = true, frequency = 60 * 60 * 24 * 7 }, -- automatically check for plugin updates every week
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  -- don't reload when config changes because it doesn't really work anyway?
  change_detection = {
    enabled = false,
  },
}
