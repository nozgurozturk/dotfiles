return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
		config = function()
			local gitsigns = require('gitsigns')

			gitsigns.setup {
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "╸" },
					topdelete = { text = "‾" },
					changedelete = { text = "┋" },
					untracked = { text = "┇" },
				},
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			}

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map('n', ']c', function()
				if vim.wo.diff then
					vim.cmd.normal({ ']c', bang = true })
				else
					gitsigns.nav_hunk('next')
				end
			end)

			map('n', '[c', function()
				if vim.wo.diff then
					vim.cmd.normal({ '[c', bang = true })
				else
					gitsigns.nav_hunk('prev')
				end
			end)

			-- Actions
			map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "[h]unk [s]tage" })
			map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "[h]unk [r]eset" })
			map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
			map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
			map('n', '<leader>hS', gitsigns.stage_buffer, { desc = "[h]unk [S]tage buffer" })
			map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = "[h]unk [u]ndo stage" })
			map('n', '<leader>hR', gitsigns.reset_buffer, { desc = "[h]unk [R]eset buffer" })
			map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "[h]unk [p]review" })
			map('n', '<leader>hd', gitsigns.diffthis, { desc = "[h]unk [d]iff" })
			map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
			map('n', '<leader>td', gitsigns.toggle_deleted)

			-- Text object
			map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
		end
	},
	{
		"sindrets/diffview.nvim",
	},
}
