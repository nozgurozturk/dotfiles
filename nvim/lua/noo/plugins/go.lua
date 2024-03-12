return {
    'ray-x/go.nvim',
    dependencies = {  -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('go').setup()

        local format_sync_grp = vim.api.nvim_create_augroup("noo-go-format", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                    -- Automatically organize imports and formats on save
                    require('go.format').goimport()
                end,
            group = format_sync_grp,
        })
    end,
    event = {'CmdlineEnter'},
    ft = {'go', 'gomod'},
}

