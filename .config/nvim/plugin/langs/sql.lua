local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'sql' } },
  mason = { ensure_installed = { 'postgrestools', 'sql-formatter' } },
  conform = {
    formatters_by_ft = {
      sql = { 'sql_formatter' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'postgres_lsp' }
end)
