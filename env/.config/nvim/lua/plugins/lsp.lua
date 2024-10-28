return {
	{
		-- Automatically install LSPs and related tools to stdpath for neovim
		"williamboman/mason.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = { ensure_installed = {} },
		config = function(_, opts)
			require("mason").setup()
			require("mason-tool-installer").setup({ ensure_installed = opts.ensure_installed })
			require("mason-lspconfig").setup({ automatic_installation = true })
		end
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { { "j-hui/fidget.nvim", opts = {} } },
		config = function(_, opts)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local telescope_builtin = require("telescope.builtin")
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", telescope_builtin.lsp_definitions, "[G]oto [D]efinition")
					map("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
					map("gI", telescope_builtin.lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", telescope_builtin.lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", telescope_builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})
			local lspconfig = require('lspconfig')

			for server, config in pairs(opts.servers) do
				lspconfig[server].setup(config)
			end
		end,
	},
	{ 'nvimtools/none-ls.nvim', dependencies = 'nvim-lua/plenary.nvim' },
}
