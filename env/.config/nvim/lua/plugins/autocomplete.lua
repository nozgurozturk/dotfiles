return {
	'saghen/blink.cmp',
	lazy = false,
	dependencies = 'rafamadriz/friendly-snippets',
	version = 'v0.*',
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = 'default',
		highlight = {
			use_nvim_cmp_as_default = false,
		},
		nerd_font_variant = 'mono',
		accept = { auto_brackets = { enabled = true } },
		trigger = {
			show_in_snippet = false,
			signature_help = { enabled = true }
		}
	}
}
