local lazy = require 'lazyload'

Config.add {
  mason = { ensure_installed = { 'harper-ls' } },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'harper_ls' }
end)
