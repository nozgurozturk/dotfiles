local nvim_lsp = require'lspconfig'
local util = require "lspconfig/util"
-- Setup lspconfig.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- ============================================================================
-- Bash Language Server Protocol
-- ============================================================================

nvim_lsp.bashls.setup{
    capabilities = capabilities,
}

-- ============================================================================
-- Go Language Server Protocol
-- ============================================================================

nvim_lsp.gopls.setup {
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  capabilities = capabilities,
}

-- ============================================================================
-- Rust Language Server Protocol
-- ============================================================================

local rust_opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
    capabilities = capabilities,
}

require('rust-tools').setup(rust_opts)

-- ============================================================================
-- TypeScript Language Server Protocol
-- ============================================================================

nvim_lsp.tsserver.setup{
    capabilities = capabilities,
}
