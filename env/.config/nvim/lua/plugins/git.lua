return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {},
    config = function()
      local gitsigns = require 'gitsigns'
      gitsigns.setup {
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '╸' },
          topdelete = { text = '‾' },
          changedelete = { text = '┋' },
          untracked = { text = '┇' },
        },
        current_line_blame = true,
        on_attach = function(bufnr)
          local function map(mode, keys, func, desc)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'Git: ' .. desc })
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gitsigns.nav_hunk 'next'
            end
          end, 'Go to next change')

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gitsigns.nav_hunk 'prev'
            end
          end, 'Go to previous change')

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk, '[h]unk [s]tage')
          map('v', '<leader>hs', function()
            gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, '[h]unk [s]tage')
          map('n', '<leader>hS', gitsigns.stage_buffer, '[h]unk [S]tage buffer')

          map('n', '<leader>hr', gitsigns.reset_hunk, '[h]unk [r]eset')
          map('v', '<leader>hr', function()
            gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, '[h]unk [r]eset')
          map('n', '<leader>hR', gitsigns.reset_buffer, '[h]unk [R]eset buffer')

          map('n', '<leader>hu', gitsigns.stage_hunk, '[h]unk [u]ndo stage')

          map('n', '<leader>hp', gitsigns.preview_hunk, '[h]unk [p]review')

          map('n', '<leader>hd', gitsigns.diffthis, '[h]unk [d]iff')
          map('n', '<leader>hD', function()
            gitsigns.diffthis '~'
          end, '[h]unk [D]iff buffer')
          map('n', '<leader>td', gitsigns.preview_hunk_inline, '[t]oggle [d]eleted')
        end,
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
  },
}
