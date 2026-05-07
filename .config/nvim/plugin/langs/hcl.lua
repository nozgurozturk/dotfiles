local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'terraform', 'hcl' } },
  mason = { ensure_installed = { 'terraform-ls', 'tflint' } },
  conform = {
    formatters_by_ft = {
      terraform = { 'terraform_fmt' },
      hcl = { 'terraform_fmt' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.lsp.enable { 'terraform_ls' }
end)
