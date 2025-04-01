vim.lsp.enable {
  'html',
  'marksman',
  'taplo',
  'yamlls',
}

return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'yaml', 'toml', 'html', 'markdown', 'markdown_inline' })
      end
    end,
  },
  -- LSP
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'yaml-language-server', 'yamlfix', 'yamlfmt', 'taplo', 'marksman' })
      end
    end,
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        yaml = { 'yamlfix', 'yamlfmt' },
        toml = { 'taplo' },
        html = { 'biome-check' },
      },
    },
  },
}
