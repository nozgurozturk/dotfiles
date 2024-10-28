return {
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'sql', 'graphql' })
			end
		end
	},
	-- LSP
	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'sql-formatter', 'graphql-language-service-cli' })
			end
		end,
	},
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				postgres_lsp = {},
			},
		},
	},
}

