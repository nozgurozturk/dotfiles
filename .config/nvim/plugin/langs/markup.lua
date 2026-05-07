local lazy = require 'lazyload'

Config.add {
  treesitter = { ensure_installed = { 'yaml', 'toml', 'html', 'markdown', 'markdown_inline' } },
  mason = { ensure_installed = { 'yaml-language-server', 'yamlfix', 'taplo', 'marksman' } },
  conform = {
    formatters = {
      yamlfix = {
        command = 'yamlfix',
        env = {
          YAMLFIX_SEQUENCE_STYLE = 'block_style',
          YAMLFIX_EXPLICIT_START = false,
          YAMLFIX_SECTION_WHITELINES = '1',
          YAMLFIX_LINE_LENGTH = '160',
          YAMLFIX_COMMENTS_REQUIRE_STARTING_SPACE = false,
        },
      },
    },
    formatters_by_ft = {
      yaml = { 'yamlfix' },
      toml = { 'taplo' },
      html = { 'biome-check' },
    },
  },
}

lazy.on_vim_enter(function()
  vim.pack.add { 'https://github.com/iamcco/markdown-preview.nvim' }
  vim.lsp.enable { 'html', 'marksman', 'taplo', 'yamlls', 'zk' }
end)
