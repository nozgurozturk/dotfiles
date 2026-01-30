vim.lsp.enable {
  'html',
  'marksman',
  'taplo',
  'yamlls',
  'zk',
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
  -- treesitter
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
    'mason-org/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'yaml-language-server', 'yamlfix', 'taplo', 'marksman' })
      end
    end,
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters = {
        yamlfix = {
          command = 'yamlfix',
          env = {
            YAMLFIX_EXPLICIT_START = false,
            YAMLFIX_SECTION_WHITELINES = '1',
            YAMLFIX_LINE_LENGTH = '160',
          },
        },
      },
      formatters_by_ft = {
        yaml = { 'yamlfix' },
        toml = { 'taplo' },
        html = { 'biome-check' },
      },
    },
  },
}
