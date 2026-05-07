local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'c_sharp' } },
  mason = { ensure_installed = { 'csharpier' } },
  conform = {
    formatters_by_ft = {
      cs = { 'csharpier' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'roslyn_ls' }
end)
