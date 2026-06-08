local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'proto' } },
  mason = { ensure_installed = { 'buf' } },
  conform = {
    formatters_by_ft = {
      proto = { 'buf' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'buf_ls' }
end)
