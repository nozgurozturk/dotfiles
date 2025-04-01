vim.lsp.enable { 'biome', 'ts_ls' }

return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'javascript', 'typescript', 'tsx', 'jsddoc', 'json5' })
      end
    end,
  },
  -- LSP
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'biome', 'typescript-language-server' })
      end
    end,
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'biome-check' },
        javascriptreact = { 'biome-check' },
        typescript = { 'biome-check' },
        typescriptreact = { 'biome-check' },
        json = { 'biome-check' },
        jsonc = { 'biome-check' },
      },
    },
  },
}
