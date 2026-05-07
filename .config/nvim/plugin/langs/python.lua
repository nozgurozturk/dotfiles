local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'python' } },
  mason = { ensure_installed = { 'basedpyright', 'ruff' } },
  conform = {
    formatters_by_ft = {
      python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'basedpyright', 'ruff' }
end)
