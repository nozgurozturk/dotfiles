return {
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'python' })
			end
		end
	},
	-- LSP
	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'basedpyright', 'ruff_lsp' })
			end
		end,
	},
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				ruff_lsp = {},
				basedpyright = {
					settings = {
						basedpyright = {
							disableOrganizeImports = true,
							analysis = {
								ignore = { "*" },
								useLibraryCodeForTypes = true,
								typeCheckingMode = "standard",
								diagnosticMode = "openFilesOnly",
								autoImportCompletions = true,
							}
						},
					},
				},
			},
		},
	},
}
