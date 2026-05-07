local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'go', 'gotmpl', 'gomod', 'gosum' } },
  mason = { ensure_installed = { 'gopls', 'golangci-lint', 'gofumpt', 'goimports' } },
  conform = {
    formatters_by_ft = {
      go = { 'gofmt', 'gofumpt', 'goimports' },
    },
  },
}

lazy.on_vim_enter(function()
  Config.autocmd({ 'BufNewFile', 'BufRead' }, '*.tmpl', function()
    if vim.fn.search('{{.\\+}}', 'nw') then
      local filename = vim.fn.expand '%:t'
      local baselang = filename:match '.*%.(%w+)%.tmpl$'
      vim.bo.filetype = baselang and ('gotmpl.' .. baselang) or 'gotmpl'
    end
  end)

  vim.lsp.enable { 'golangci_lint_ls', 'gopls' }
end)
