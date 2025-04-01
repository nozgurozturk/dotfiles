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
map({ 'i', 'n' }, '<esc>', '<Cmd>nohlsearch<CR>', { desc = 'Escape and clear hlsearch' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.get_next, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- File editing
map({ 'v', 'n' }, '<C-J>', 'mzJ`z', { desc = '[J]oin selected lines in visual mode or [J]oin current line with the next in normal mode' })

-- Clipboard
map('x', 'p', [["_dP]], { desc = 'Paste without overwriting the default register' })
map({ 'n', 'v' }, 'd', [["_d]], { desc = 'Cut without overwriting the default register' })

-- LSP
map('n', 'gd', vim.lsp.buf.definition, { desc = '[g]o to [d]efinition' })
-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
map('n', 'gD', vim.lsp.buf.declaration, { desc = '[g]o to [D]eclaration' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = '[g]o to [i]mplementation' })
map('n', 'gt', vim.lsp.buf.type_definition, { desc = '[g]o to [t]type definition' })
map('n', 'fs', vim.lsp.buf.document_symbol, { desc = '[f]ind [s]ymbol in current document' })
map('n', 'fS', vim.lsp.buf.workspace_symbol, { desc = '[f]ind [S]ymbol in current workspace' })

map('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[r]e[n]ame' })
map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Show [K]eyword information' })
