return {
  {
    -- Automatically install LSPs and related tools to stdpath for neovim
    'mason-org/mason.nvim',
    opts = {},
    config = function(_, opts)
      require('mason').setup(opts)
    end,
  },
}
