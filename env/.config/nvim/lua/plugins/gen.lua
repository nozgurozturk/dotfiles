return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'gemini',
        },
        inline = {
          adapter = 'gemini',
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
      local function map(mode, keys, func, desc)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { desc = 'AI: ' .. desc, noremap = true, silent = true })
      end

      require('codecompanion').setup(opts)

      map({ 'n', 'v' }, '<C-\\>', '<cmd>CodeCompanionActions<cr>', 'CodeCompanionActions')
    end,
  },
  {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
    config = function()
      vim.g.codeium_manual = true
      vim.g.codeium_no_map_tab = true

      vim.keymap.set('i', '<C-y>', function()
        return vim.fn['codeium#Accept']()
      end, { expr = true, silent = true })
    end,
  },
}
