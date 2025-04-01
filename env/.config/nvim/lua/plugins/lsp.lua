return {
  {
    -- Automatically install LSPs and related tools to stdpath for neovim
    'williamboman/mason.nvim',
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    opts = {
      log_level = vim.log.levels.OFF,
      ensure_installed = {},
    },
    config = function(_, opts)
      require('mason').setup()
      require('mason-tool-installer').setup { ensure_installed = opts.ensure_installed }
    end,
  },
}
