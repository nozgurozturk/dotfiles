--stylua: ignore start

-- General ====================================================================
vim.g.mapleader = ' ' -- Use `<Space>` as a leader key

vim.o.mouse       = 'a'            -- Enable mouse
vim.o.mousescroll = 'ver:1,hor:6'  -- Customize mouse scroll
vim.o.switchbuf   = 'usetab'       -- Use already opened buffers when switching
vim.o.undofile    = true           -- Enable persistent undo
vim.o.undodir     = os.getenv 'HOME' .. '/.vim/undodir'

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Enable all filetype plugins and syntax
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- UI =========================================================================
vim.o.breakindent     = true       -- Indent wrapped lines to match line start
vim.o.breakindentopt  = 'list:-1'  -- Add padding for lists (if 'wrap' is set)
vim.o.colorcolumn     = '+1'       -- Draw column on the right of maximum width
vim.o.cursorline      = true       -- Enable current line highlighting
vim.o.linebreak       = true       -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.list            = true       -- Show helpful text indicators
vim.o.relativenumber  = true       -- Show relative line numbers
vim.o.pumheight       = 10         -- Make popup menu smaller
vim.o.ruler           = false      -- Don't show cursor coordinates
vim.o.shortmess       = 'CFOSWaco' -- Disable some built-in completion messages
vim.o.showmode        = false      -- Don't show mode in command line
vim.o.signcolumn      = 'yes'      -- Always show signcolumn (less flicker)
vim.o.splitbelow      = true       -- Horizontal splits will be below
vim.o.splitkeep       = 'screen'   -- Reduce scroll during window split
vim.o.splitright      = true       -- Vertical splits will be to the right
vim.o.wrap            = false      -- Don't visually wrap lines (toggle with \w)
vim.o.cursorlineopt   = 'screenline,number' -- Show cursor line per screen line
vim.o.termguicolors   = true
vim.o.hlsearch        = true

-- Special UI symbols
vim.o.fillchars = 'eob: ,fold:╌'
vim.o.listchars = 'tab:│ ,trail:·,nbsp:␣'

-- Folds (default behavior; see `:h Folding`)
vim.o.foldcolumn     = "0"
vim.o.foldmethod     = "expr"
vim.o.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext       = "v:lua.require('fold').foldtext()"
vim.o.foldenable     = true
vim.o.foldlevel      = 99
vim.o.foldlevelstart = 99

-- Editing ====================================================================
vim.o.autoindent    = true       -- Use auto indent
vim.o.expandtab     = true       -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j'   -- Improve comment editing
vim.o.ignorecase    = true       -- Ignore case during search
vim.o.incsearch     = true       -- Show search matches while typing
vim.o.infercase     = true       -- Infer case in built-in completion
vim.o.shiftwidth    = 2          -- Use this number of spaces for indentation
vim.o.smartcase     = true       -- Respect case if search pattern has upper case
vim.o.smartindent   = true       -- Make indenting smart
vim.o.spelllang     = 'en'       -- Define spelling dictionaries
vim.o.spelloptions  = 'camel'    -- Treat camelCase word parts as separate words
vim.o.tabstop       = 2          -- Show tab as this number of spaces
vim.o.virtualedit   = 'block'    -- Allow going past end of line in blockwise mode

vim.o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

-- Pattern for a start of 'numbered' list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Completion ================================================================
vim.o.complete        = "o,.,w,b,u"                       -- Use less sources
vim.o.completeopt     = "menuone,popup,noselect,fuzzy,nosort"   -- Use custom behavior
vim.o.completetimeout = 100
vim.o.autocomplete    = true
vim.o.pumborder       = "rounded"
vim.o.pumheight       = 7
vim.o.pummaxwidth     = 100 -- Limit maximum width of popup menu

-- Diff ======================================================================
vim.o.diffopt = 'internal,filler,closeoff,indent-heuristic,inline:char,context:12,algorithm:histogram,linematch:200'

-- Diagnostics ================================================================
local diagnostic_opts = {
  -- Show signs on top of any other sign, but only for warnings and errors
  signs = {
    priority = 9999, 
    severity = { min = 'WARN', max = 'ERROR' },
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = '',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
  -- Show more details immediately only for errors at current line end
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = 'ERROR', max = 'ERROR' },
  },

  -- Don't update diagnostics when typing
  update_in_insert = false,

  -- Show all diagnostics as underline (for their meessages type `<Leader>ld`)
  underline = { severity = { min = 'HINT', max = 'ERROR' } },

  severity_sort = true,

  float = {
    focusable = false,
    style = 'minimal',
    source = true,
  },
}

require('lazyload').on_vim_enter(function()
	vim.diagnostic.config(diagnostic_opts)
end)

--stylua: ignore end
