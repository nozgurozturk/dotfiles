local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'yaml', 'helm' } },
  mason = { ensure_installed = { 'helm-ls' } },
  conform = {
    formatters_by_ft = {
      helm = { lsp_format = 'prefer' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.pack.add { 'https://github.com/towolf/vim-helm' }
  vim.lsp.enable { 'helm_ls' }
end)
