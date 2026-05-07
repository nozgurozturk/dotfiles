require('lazyload').on_vim_enter(function()
  vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

  require('conform').setup {
    default_format_opts = { lsp_format = 'fallback' },
    format_after_save = { lsp_format = 'fallback' },
    formatters = Config.conform.formatters,
    formatters_by_ft = Config.conform.formatters_by_ft,
  }
end)
