local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'rust' } },
  mason = { ensure_installed = { 'rust-analyzer' } },
  conform = {
    formatters_by_ft = {
      rust = { 'rustfmt' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'rust_analyzer' }
end)
