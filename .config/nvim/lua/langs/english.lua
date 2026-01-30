vim.lsp.enable { 'harper_ls' }

return {
  -- LSP
  {
    'mason-org/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'harper-ls' })
      end
    end,
  },
}
