-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
local YankGroup = augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = YankGroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Automatically format code on save
-- See `:help autocmd-events` for a list of events
-- See `:help vim.lsp.buf.format()` for more information
local AutoFormatGroup = augroup("AutoFormat", {})
autocmd("BufWritePre", {
	group = AutoFormatGroup,
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
