vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = vim.api.nvim_create_augroup('ftd_gotmpl', { clear = true }),
  pattern = '*.tmpl',
  callback = function()
    if vim.fn.search('{{.\\+}}', 'nw') then
      local filename = vim.fn.expand '%:t'
      local baselang = filename:match '.*%.(%w+)%.tmpl$'

      vim.bo.filetype = baselang and ('gotmpl.' .. baselang) or 'gotmpl'
    end
  end,
})

return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'go', 'gotmpl', 'gomod', 'gosum' })
      end

      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.gotmpl = {
        install_info = {
          url = 'https://github.com/ngalaiko/tree-sitter-go-template',
          files = { 'src/parser.c' },
        },
        filetype = 'gotmpl',
        used_by = { 'gohtmltmpl', 'gotexttmpl', 'gotmpl' },
      }
    end,
  },
  -- LSP
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'gopls', 'golangci_lint_ls', 'gofumpt', 'goimports' })
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        gopls = {
          analyses = {
            shadow = true,
            unusedvariable = true,
          },
          vulncheck = true,
          staticcheck = true,
          gofumpt = true,
        },
        golangci_lint_ls = {},
      },
    },
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        go = { 'gofmt', 'gofumpt', 'goimports' },
      },
    },
  },
}
