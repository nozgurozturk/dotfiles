-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
local YankGroup = augroup('HighlightYank', { clear = true })
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = YankGroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

local LspGroup = augroup('LspGroup', {})
autocmd('LspAttach', {
  group = LspGroup,
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    ---@diagnostic disable-next-line need-check-nil
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      -- vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end
    ---@diagnostic disable-next-line need-check-nil
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end

    -- -- nightly has inbuilt completions, this can replace all completion plugins
    -- if client:supports_method("textDocument/completion", bufnr) then
    --   -- Enable auto-completion
    --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    -- end

    --- Disable semantic tokens
    ---@diagnostic disable-next-line need-check-nil
    client.server_capabilities.semanticTokensProvider = nil
  end,
})
