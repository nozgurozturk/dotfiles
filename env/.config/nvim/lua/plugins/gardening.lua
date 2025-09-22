return {
  'zk-org/zk-nvim',
  config = function()
    require('zk').setup {
      picker = 'telescope',
      lsp = {
        config = {
          name = 'zk',
          cmd = { 'zk', 'lsp' },
          filetypes = { 'markdown' },
          root_dir = function()
            return vim.loop.cwd()
          end,
        },

        auto_attach = {
          enabled = true,
        },
      },
    }
  end,
}
