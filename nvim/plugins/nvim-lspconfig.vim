" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
" auto-format
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.go lua goimports(1000)
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync(nil, 100)
" show-diagnostics
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()