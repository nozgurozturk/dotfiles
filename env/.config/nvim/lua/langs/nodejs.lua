vim.lsp.enable { 'biome', 'ts_ls', 'graphql-lsp' }

return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'javascript', 'typescript', 'tsx', 'jsddoc', 'json5', 'graphql' })
      end
    end,
  },
  -- LSP
  {
    'mason-org/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'biome', 'typescript-language-server', 'graphql-language-service-cli' })
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
        typescript = { 'prettier', 'biome-check', stop_after_first = true },
        typescriptreact = { 'prettier', 'biome-check', stop_after_first = true },
        json = { 'biome-check' },
        jsonc = { 'biome-check' },
        graphql = { 'biome-check' },
      },
    },
  },
}
