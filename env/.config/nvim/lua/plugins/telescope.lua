return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
  },
  config = function()
    local vimgrep_arguments = { unpack(require('telescope.config').values.vimgrep_arguments) }
    -- Show hidden files
    table.insert(vimgrep_arguments, '--hidden')
    -- Don't search .git directory
    table.insert(vimgrep_arguments, '--glob')
    table.insert(vimgrep_arguments, '!**/.git/*')

    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
      },
      pickers = {
        find_files = {
          find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/.' },
        },
      },
    }

    local function map(mode, keys, func, desc)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { desc = 'Search: ' .. desc })
    end

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'

    map('n', '<leader>sh', builtin.help_tags, '[S]earch [H]elp')
    map('n', '<leader>sk', builtin.keymaps, '[S]earch [K]eymaps')
    map('n', '<leader>sf', builtin.find_files, '[S]earch [F]iles')
    map('n', '<leader>ss', builtin.builtin, '[S]earch [S]elect Telescope')
    map('n', '<leader>sw', builtin.grep_string, '[S]earch current [W]ord')
    map('n', '<leader>sg', builtin.live_grep, '[S]earch by [G]rep')
    map('n', '<leader>sd', builtin.diagnostics, '[S]earch [D]iagnostics')
    map('n', '<leader>sr', builtin.resume, '[S]earch [R]esume')
    map('n', '<leader>s.', builtin.oldfiles, '[S]earch Recent Files ("." for repeat)')
    map('n', '<leader><leader>', builtin.buffers, '[ ] Find existing buffers')

    -- Slightly advanced example of overriding default behavior and theme
    map('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, '[/] Fuzzily search in current buffer')

    map('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, '[S]earch [/] in Open Files')

    map('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, '[S]earch [N]eovim files')
  end,
}
