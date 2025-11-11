local function map(mode, lhs, rhs, opts)
  opts = opts or { noremap = true }
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

map('n', '<leader>fr', ':%s//g<left><left>', { desc = '[f]ind and [r]eplace' })
map({ 'n', 'v' }, '<leader>rr', '[[:%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left>]]', { desc = 'Search and replace word under cursor' })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-m>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-n>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-e>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-i>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Move Lines
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected line down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected line up' })

-- Clear search with <esc>
map({ 'n' }, '<esc>', '<Cmd>nohlsearch<CR>', { desc = 'Escape and clear hlsearch' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

local diagnostic_goto = function(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { count = count, severity = severity }
  end
end

map('n', '<leader>d]', diagnostic_goto(1), { desc = 'Next Diagnostic' })
map('n', '<leader>d[', diagnostic_goto(-1), { desc = 'Prev Diagnostic' })
map('n', '<leader>e]', diagnostic_goto(1, 'ERROR'), { desc = 'Next Error' })
map('n', '<leader>e[', diagnostic_goto(-1, 'ERROR'), { desc = 'Prev Error' })
map('n', '<leader>w]', diagnostic_goto(1, 'WARN'), { desc = 'Next Warning' })
map('n', '<leader>w[', diagnostic_goto(-1, 'WARN'), { desc = 'Prev Warning' })
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
map('n', 'gd', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'definition'}) <cr>", { desc = '[g]o to [d]efinitions' })
map('n', 'gD', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'declaration'}) <cr>", { desc = '[g]o to [D]eclaration' })
map('n', 'gr', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'references'}) <cr>", { desc = '[g]o to [r]eferences' })
map('n', 'gi', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'implementation'}) <cr>", { desc = '[g]o to [i]mplementation' })
map('n', 'gt', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'type_definition'}) <cr>", { desc = '[g]o to [t]type definition' })
map('n', 'fs', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'document_symbol'}) <cr>", { desc = '[f]ind [s]ymbol in current document' })
map('n', 'fS', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'workspace_symbol'}) <cr>", { desc = '[f]ind [S]ymbol in current workspace' })
map('n', 'gH', vim.lsp.buf.signature_help, { desc = '[g]o to signature [h]elp' })

map('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[r]e[n]ame' })

map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Show [K]eyword information' })

-- Picker
map('n', '<leader>sg', '<cmd>lua MiniPick.builtin.grep_live()<cr>', { desc = 'Grep live' })
map('n', '<leader>sb', '<cmd>lua MiniPick.builtin.buffers()<cr>', { desc = 'Buffers' })
map('n', '<leader>sf', '<cmd>lua MiniPick.builtin.files()<cr>', { desc = 'Files' })
map('n', '<leader>sG', '<cmd>lua MiniPick.builtin.grep()<cr>', { desc = 'Grep' })
map('n', '<leader>ph', '<cmd>lua MiniPick.builtin.help()<cr>', { desc = 'Help' })
map('n', '<leader>s/', "<cmd>lua MiniExtra.pickers.history({ scope = '/' })<cr>", { desc = 'Search history' })
map('n', '<leader>s:', "<cmd>lua MiniExtra.pickers.history({ scope = ':' })<cr>", { desc = 'Commands hitory' })
map('n', '<leader>sd', '<cmd>lua MiniExtra.pickers.diagnostic()<cr>', { desc = 'Diagnostics' })
map('n', '<leader>sk', '<cmd>lua MiniExtra.pickers.keymaps()<cr>', { desc = 'Keymaps' })
map('n', '<leader>sl', "<cmd>lua MiniExtra.pickers.buf_lines({ scope = 'current' })<cr>", { desc = 'Lines' })
map('n', '<leader>so', '<cmd>lua MiniExtra.pickers.options()<cr>', { desc = 'Options' })
map('n', '<leader>sr', '<cmd>lua MiniExtra.pickers.registers()<cr>', { desc = 'Registers' })
map('n', '<leader>st', '<cmd>lua MiniExtra.pickers.hipatterns()<cr>', { desc = 'Todos' })
map('n', '<leader>sc', '<cmd>lua MiniExtra.pickers.hl_groups()<cr>', { desc = 'Colors' })

-- AI
map({ 'n', 'v' }, '<A-\\>', '<cmd>CodeCompanionActions<cr>', { desc = 'CodeCompanionActions' })

-- Gardening
map('n', '<leader>zg', '<cmd>ZkNotes<CR>', { desc = '[Z]ettelkasten search notes' })
map('n', '<leader>zn', '<cmd>ZkNew<CR>', { desc = '[Z]ettelkasten new note' })
map('n', '<leader>zl', '<cmd>ZkLinks<CR>', { desc = '[Z]ettelkasten show links' })
map('n', '<leader>zb', '<cmd>ZkBacklinks<CR>', { desc = '[Z]ettelkasten show backlinks' })

-- Git
-- Here, we map it to `<leader>gl` (leader is typically the backslash key).
map('n', '<leader>hl', '<cmd>GitLink<CR>', {
  noremap = true,
  silent = true,
  desc = 'Open Git link for current line',
})
