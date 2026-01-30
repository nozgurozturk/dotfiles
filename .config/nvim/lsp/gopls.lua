---@type vim.lsp.Config
return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', 'go.sum' },
  settings = {
    autoformat = true,
    analyses = {
      shadow = true,
      nilness = true,
      unusedwrite = true,
      unusedvariable = true,
      unusedparams = true,
    },
    vulncheck = true,
    gofumpt = true,
    staticcheck = true,
    semanticTokens = true,
  },
}
