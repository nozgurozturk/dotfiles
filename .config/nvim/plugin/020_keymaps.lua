-- Basic mappings =============================================================

-- stylua: ignore start

-- create global tables with information about clue groups in certain modes
-- Structure of tables is taken to be compatible with 'mini.clue'.
Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+GoTo' },
  { mode = 'n', keys = '<Leader>h', desc = '+Hunk' },
  { mode = 'n', keys = '<Leader>l', desc = '+Language' },
  { mode = 'n', keys = '<Leader>v', desc = '+Visits' },

  { mode = 'x', keys = '<Leader>l', desc = '+Language' },
}

-- create mappings
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

-- ai
map({ 'n', 'v' }, '<A-\\>', '<cmd>CodeCompanionActions<cr>', 'CodeCompanionActions')

-- editing
map('v',          'J',     ":m '>+1<CR>gv=gv", 'Move selected line down')
map('v',          'K',     ":m '<-2<CR>gv=gv", 'Move selected line up')
map({ 'v', 'n' }, '<C-J>', 'mzJ`z',            'Join selected lines in visual mode or join current line with the next in normal mode')

map('v', '<', '<gv', 'Indent Left')
map('v', '>', '>gv', 'Indent Right')

-- clipboard
map('v',          'p', [["_dP]], 'Paste without overwriting the default register')
map({ 'n', 'v' }, 'd', [["_d]],  'Cut without overwriting the default register')

-- language
map('n', 'K', vim.lsp.buf.hover, 'Hover')

-- window navigation
map('n', '<C-m>', '<C-w>h', 'Focus Left window')
map('n', '<C-n>', '<C-w>j', 'Focus Lower window')
map('n', '<C-e>', '<C-w>k', 'Focus Upper window')
map('n', '<C-i>', '<C-w>l', 'Focus Right window')

-- file navigation
map('n', '-', '<cmd>Oil<cr>', 'Open parent directory')

-- highlight
map('n', '<esc>', '<cmd>nohlsearch<cr>', 'Escape and clear hlsearch' )

-- create `<Leader>` mappings
local map_leader  = function(mode, suffix, rhs, desc)
  vim.keymap.set(mode, '<Leader>' .. suffix, rhs, { desc = desc })
end

-- e is for 'Explore' and 'edit'
map_leader('n', 'eq', '<cmd>Picker list scope="quickfix"<cr>',       'Quickfix')
map_leader('n', 'el', '<cmd>Picker list scope="location-list"<cr>',  'Location')

-- f is for 'Find'
map_leader('n', 'f/', '<cmd>Pick history scope="/"<cr>',                  '"/" history')
map_leader('n', 'f:', '<cmd>Pick history scope=":"<cr>',                  '":" history')
map_leader('n', 'fb', '<cmd>Pick buffers<cr>',                            'Buffers')
map_leader('n', 'fd', '<cmd>Pick diagnostic scope="all"<cr>',             'Diagnostic workspace')
map_leader('n', 'fD', '<cmd>Pick diagnostic scope="current"<cr>',         'Diagnostic buffer')
map_leader('n', 'ff', '<cmd>Pick files<cr>',                              'Files')
map_leader('n', 'fg', '<cmd>Pick grep_live<cr>',                          'Grep live')
map_leader('n', 'fG', '<cmd>Pick grep pattern="<cword>"<cr>',             'Grep current word')
map_leader('n', 'fh', '<cmd>Pick git_hunks scope="staged"<cr>',           'Added hunks (all)')
map_leader('n', 'fH', '<cmd>Pick git_hunks path="%" scope="staged"<cr>',  'Added hunks (buf)')
map_leader('n', 'fv', '<cmd>Pick visit_paths cwd=""<cr>',                 'Visit paths (all)')
map_leader('n', 'fV', '<cmd>Pick visit_paths<cr>',                        'Visit paths (cwd)')

-- g is for 'Go to'
map_leader('n', 'gd', '<cmd>Pick lsp scope="definition"<cr>',             'Definition')
map_leader('n', 'gD', '<cmd>Pick lsp scope="declaration"<cr>',            'Declaration')
map_leader('n', 'gi', '<cmd>Pick lsp scope="implementation"<cr>',         'Implementation')
map_leader('n', 'gr', '<cmd>Pick lsp scope="references"<cr>',             'References')
map_leader('n', 'gt', '<cmd>Pick lsp scope="type_definition"<cr>',        'Type definition')

-- h is for 'Hunk (git)'
map_leader('n', 'h]', '<cmd>Gitsigns nav_hunk next<cr>',    'Next change')
map_leader('n', 'h[', '<cmd>Gitsigns nav_hunk prev<cr>',    'Previous change')
map_leader('n', 'hd', '<cmd>Gitsigns diffthis<cr>',         'Diff current buffer')
map_leader('n', 'hs', '<cmd>Gitsigns stage_hunk<cr>',       'Stage/Unstage hunk')
map_leader('n', 'hS', '<cmd>Gitsigns stage_buffer<cr>',     'Stage/Unstage buffer')
map_leader('n', 'hp', '<cmd>Gitsigns preview_hunk<cr>',     'Preview hunk')
map_leader('n', 'hr', '<cmd>Gitsigns reset_hunk<cr>',       'Reset hunk')
map_leader('n', 'hR', '<cmd>Gitsigns reset_buffer<cr>',     'Reset buffer')

-- l is for 'Language'
map_leader('n',          'la', '<cmd>lua vim.lsp.buf.code_action()<cr>',      'Actions')
map_leader('n',          'ld', '<cmd>lua vim.diagnostic.open_float()<cr>',    'Diagnostic popup')
map_leader({ 'n', 'x' }, 'lf', '<cmd>lua require("conform").format()<cr>',    'Format')

map_leader('n',          'rn', '<cmd>lua vim.lsp.buf.rename()<cr>',           'Rename')

-- v is for 'Visits'
map_leader('n', 'va', '<cmd>lua MiniVisits.add_label()<cr>', 'Add label')
map_leader('n', 'vl', '<cmd>lua MiniVisits.remove_label()<cr>', 'Remove label')
