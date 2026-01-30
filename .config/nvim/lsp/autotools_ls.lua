---@type vim.lsp.Config
return {
  cmd = { 'autotools-language-server' },
  filetypes = { 'config', 'automake', 'make' },
  root_markers = { 'configure.ac', 'Makefile', 'Makefile.am', '*.mk' },
}
