---@type vim.lsp.Config
return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { '.graphqlrc*', '.graphql.config.*', 'graphql.config.*' },
}
