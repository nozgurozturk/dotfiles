local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'bash', 'tmux', 'jq', 'make' } },
  mason = { ensure_installed = { 'bash-language-server', 'autotools-language-server' } },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'autotools_ls', 'bashls' }
end)
