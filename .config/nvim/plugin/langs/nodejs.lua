local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'javascript', 'typescript', 'tsx', 'jsdoc', 'json5' } },
  mason = { ensure_installed = { 'biome', 'typescript-language-server' } },
  conform = {
    formatters_by_ft = {
      javascript = { 'biome-check' },
      javascriptreact = { 'biome-check' },
      typescript = { 'prettier', 'biome-check', stop_after_first = true },
      typescriptreact = { 'prettier', 'biome-check', stop_after_first = true },
      json = { 'biome-check' },
      jsonc = { 'biome-check' },
      graphql = { 'biome-check' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'biome', 'ts_ls' }
end)
