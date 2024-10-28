return {
	'nvim-lualine/lualine.nvim',
	opts = {
		options = {
			icons_enabled = false,
			section_separators = '',
			component_separators = ''
		},
		sections = {
			lualine_a = { 'mode' },
			lualine_b = { 'branch' },
			lualine_c = { { 'filename', path = 3 } },
			lualine_x = {
				{
					'diagnostics',
					sources = { 'nvim_diagnostic', 'nvim_lsp' },
					sections = { 'error', 'warn', 'info', 'hint' },
					diagnostics_color = {
						error = 'DiagnosticError', -- Changes diagnostics' error color.
						warn  = 'DiagnosticWarn', -- Changes diagnostics' warn color.
						info  = 'DiagnosticInfo', -- Changes diagnostics' info color.
						hint  = 'DiagnosticHint', -- Changes diagnostics' hint color.
					},
					symbols = { error = " ", warn = " ", info = " ", hint = " " },
					colored = true,
					update_in_insert = false,
					always_visible = false,
				}
			},
			lualine_y = { 'filetype' },
			lualine_z = { "require'lsp-status'.status()" }
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { 'filename' },
			lualine_x = { 'diagnostics' },
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {}
	}
}
