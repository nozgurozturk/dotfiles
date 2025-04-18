return {
  {
    'github/copilot.vim',
    config = function()
      -- Disable copilot by default
      vim.g.copilot_enabled = false
      vim.g.copilot_no_tab_map = true

      local function toggle()
        vim.fn['copilot#Clear']()
        if vim.g.copilot_enabled then
          vim.g.copilot_enabled = false
        else
          vim.g.copilot_enabled = true
        end
      end

      local function map(mode, keys, func, opts)
        mode = mode or 'n'

        opts.desc = 'AI: ' .. opts.desc
        opts.noremap = true
        opts.silent = true

        vim.keymap.set(mode, keys, func, opts)
      end

      map('i', '<C-\\>', toggle, { desc = 'Toggle Copilot' })
      map('i', '<C-y>', 'copilot#Accept("\\<CR>")', { desc = 'Accept Copilot suggestion', expr = true, replace_keycodes = false })
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
          keymaps = {
            accept_change = {
              modes = { n = '<C-y>' },
              description = 'Accept the suggested change',
            },
            reject_change = {
              modes = { n = '<C-c>' },
              description = 'Reject the suggested change',
            },
          },
        },
      },
    },
    config = function(_, opts)
      local function map(mode, keys, func, opts)
        mode = mode or 'n'

        opts.desc = 'AI: ' .. opts.desc
        opts.noremap = true
        opts.silent = true

        vim.keymap.set(mode, keys, func, opts)
      end
      require('codecompanion').setup(opts)

      map({ 'n', 'v' }, '<C-\\>', '<cmd>CodeCompanionActions<cr>', { desc = 'CodeCompanionActions' })
    end,
  },
}
