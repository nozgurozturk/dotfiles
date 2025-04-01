local omnisharp_bin = vim.fn.expand '$HOME/.local/share/nvim/mason/packages/omnisharp-mono/run'

---@type vim.lsp.Config
return {
  cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(vim.fn.getpid()) },
  filetypes = { 'cs', 'vb' },
  root_markers = { '*.sln', '*.csproj', 'omnisharp.json', 'function.json' },
}
