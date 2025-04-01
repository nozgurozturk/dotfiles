vim.lsp.enable { 'helm_ls' }

return {
  { 'towolf/vim-helm', ft = 'helm' },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'yaml', 'helm' })
      end
    end,
  },
  -- LSP
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'helm-ls' })
      end
    end,
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        helm = { 'yamlfix', 'yamlfmt', lsp_format = 'prefer' },
      },
    },
  },
}
