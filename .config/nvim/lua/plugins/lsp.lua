return {
  {
    -- Automatically install LSPs and related tools to stdpath for neovim
    'mason-org/mason.nvim',
    opts = { ensure_installed = {} },
    config = function(_, opts)
      require('mason').setup()
      -- Create a command to install all packages in ensure_installed
      vim.api.nvim_create_user_command('MasonInstallAll', function()
        local packages = table.concat(opts.ensure_installed, ' ')
        vim.cmd('MasonInstall ' .. packages)
      end, {})
    end,
  },
  {
    'j-hui/fidget.nvim',
    opts = {},
  },
}
