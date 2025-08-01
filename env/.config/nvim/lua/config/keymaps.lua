local function map(mode, lhs, rhs, opts)
  opts = opts or { noremap = true }
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

map('n', '<leader>fr', ':%s//g<left><left>', { desc = '[f]ind and [r]eplace' })
map('n', '<leader>rr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Search and replace word under cursor' })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-m>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-n>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-e>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-i>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Move Lines
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected line down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected line up' })

-- Clear search with <esc>
-- map({ 'i', 'n' }, '<esc>', '<Cmd>nohlsearch<CR>', { desc = 'Escape and clear hlsearch' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

local diagnostic_goto = function(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { count, severity }
  end
end

map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(1), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(-1), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(1, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(-1, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(1, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(-1, 'WARN'), { desc = 'Prev Warning' })
map('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Options
map('n', '<leader>uw', '<cmd>set wrap!<cr>', { desc = 'Toggle line wrapping' })
map('n', '<leader>uc', function()
  local value = vim.opt.conceallevel
  vim.opt.conceallevel = value == 0 and 2 or 0
end, { desc = 'Toggle conceal' })

-- File editing
map({ 'v', 'n' }, '<C-J>', 'mzJ`z', { desc = '[J]oin selected lines in visual mode or [J]oin current line with the next in normal mode' })

-- Clipboard
map('x', 'p', [["_dP]], { desc = 'Paste without overwriting the default register' })
map({ 'n', 'v' }, 'd', [["_d]], { desc = 'Cut without overwriting the default register' })

-- LSP
local definition_goto = function()
  local builtin = require 'telescope.builtin'
  return builtin.lsp_definitions()
end

map('n', 'gd', definition_goto, { desc = '[g]o to [d]efinition' })

-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
map('n', 'gD', vim.lsp.buf.declaration, { desc = '[g]o to [D]eclaration' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = '[g]o to [i]mplementation' })
map('n', 'gt', vim.lsp.buf.type_definition, { desc = '[g]o to [t]type definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = '[g]o to [r]eferences' })
map('n', 'fs', vim.lsp.buf.document_symbol, { desc = '[f]ind [s]ymbol in current document' })
map('n', 'fS', vim.lsp.buf.workspace_symbol, { desc = '[f]ind [S]ymbol in current workspace' })

map('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[r]e[n]ame' })
map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Show [K]eyword information' })
