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
        vim.list_extend(opts.ensure_installed, { 'biome', 'denols', 'ts_ls' })
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        biome = {},
        denols = {},
        ts_ls = {},
      },
    },
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'biome' },
        javascriptreact = { 'biome' },
        typescript = { 'biome' },
        typescriptreact = { 'biome' },
        json = { 'biome' },
        jsonc = { 'biome' },
      },
    },
  },
}
