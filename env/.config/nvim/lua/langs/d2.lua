return {
  { 'terrastruct/d2-vim', ft = 'd2' },
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'd2' })
      end

      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.d2 = {
        install_info = {
          url = 'https://github.com/pleshevskiy/tree-sitter-d2',
          revision = 'main',
          files = { 'src/parser.c', 'src/scanner.cc' },
        },
        filetype = 'd2',
      }
    end,
  },
  -- formatting (conform)
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        d2 = {},
      },
    },
  },
}
