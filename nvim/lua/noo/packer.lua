-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { { 'nvim-lua/plenary.nvim' } } }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'rebelot/kanagawa.nvim'
    use 'arcticicestudio/nord-vim'
    use 'theprimeagen/harpoon'
    use 'theprimeagen/vim-be-good'
    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Required
            { 'hrsh7th/cmp-nvim-lsp' },     -- Required
            { 'hrsh7th/cmp-buffer' },       -- Optional
            { 'hrsh7th/cmp-path' },         -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' },     -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        }
    }

    use 'nvim-lualine/lualine.nvim'
    use 'numToStr/Comment.nvim'
    use 'folke/which-key.nvim'
    use 'github/copilot.vim'
    use 'onsails/lspkind.nvim'
    use {
        'm4xshen/hardtime.nvim',
        requires = { 'MunifTanjim/nui.nvim', "nvim-lua/plenary.nvim" }
    }
end)
