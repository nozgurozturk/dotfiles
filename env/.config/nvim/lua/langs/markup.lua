return {
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'yaml', 'toml', 'html' })
			end
		end,
	},
	-- LSP
	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'yamlls', 'taplo', 'html' })
			end
		end,
	},
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				yamlls = {},
				taplo = {},
				html = {},
			},
		},
	},
}
