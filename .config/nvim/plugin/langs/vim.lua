local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'vim', 'vimdoc', 'diff', 'query' } },
  mason = { ensure_installed = { 'vim-language-server' } },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'vimls' }
end)
