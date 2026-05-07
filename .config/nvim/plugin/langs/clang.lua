local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'c', 'cpp' } },
  mason = { ensure_installed = { 'clangd' } },
  conform = {
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'clangd' }
end)
