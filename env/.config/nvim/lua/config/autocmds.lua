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
