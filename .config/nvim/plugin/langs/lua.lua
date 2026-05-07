local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'lua', 'luadoc' } },
  mason = { ensure_installed = { 'lua-language-server', 'stylua' } },
  conform = {
    formatters_by_ft = {
      lua = { 'stylua' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'lua_ls' }
end)
