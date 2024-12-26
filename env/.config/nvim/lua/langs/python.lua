return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'python' })
      end
    end,
  },
  -- LSP
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'basedpyright', 'ruff' })
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ruff = {
          init_options = {
            settings = {
              -- Ruff language server settings go here
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
              analysis = {
                ignore = { '*' },
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'standard',
                diagnosticMode = 'openFilesOnly',
                autoImportCompletions = true,
              },
            },
          },
        },
      },
    },
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      },
    },
  },
}