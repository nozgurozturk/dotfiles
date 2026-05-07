local lazy = require 'lazyload'

lazy.on_vim_enter(function()
  vim.pack.add {
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/j-hui/fidget.nvim',
  }

  require('mason').setup()

  vim.api.nvim_create_user_command('MasonInstallAll', function()
    local packages = table.concat(Config.mason.ensure_installed, ' ')
    vim.cmd('MasonInstall ' .. packages)
  end, {})

  require('fidget').setup()
end)
