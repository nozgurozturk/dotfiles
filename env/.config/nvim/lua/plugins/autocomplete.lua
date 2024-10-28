return {
	'saghen/blink.cmp',
	lazy = false, -- lazy loading handled internally
	dependencies = 'rafamadriz/friendly-snippets',
	version = 'v0.*',
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		highlight = {
			use_nvim_cmp_as_default = false,
		},
		nerd_font_variant = 'mono',
		accept = { auto_brackets = { enabled = true } },
		trigger = { signature_help = { enabled = true } }
	}
}
