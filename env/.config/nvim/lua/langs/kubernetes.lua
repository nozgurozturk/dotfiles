return {
	{ "towolf/vim-helm", ft = "helm" },

	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'yaml', 'helm' })
			end
		end,
	},
	-- LSP
	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'helm_ls' })
			end
		end,
	},
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				helm_ls = {},
			},
		},
	},
}
