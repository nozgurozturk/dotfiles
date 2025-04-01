vim.lsp.enable { 'omnisharp' }

return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'c_sharp' })
      end
    end,
  },
  -- LSP
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { { 'omnisharp-mono', version = 'v1.38.2' }, { 'csharpier', version = '0.29.2' } })
      end
    end,
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        cs = { 'csharpier' },
      },
    },
  },
}
