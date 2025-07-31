return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  lazy = true,
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>cF',
      function()
        require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
      end,
      mode = { 'n', 'v' },
      desc = 'Format injected langs',
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    async = true,
    -- Set default options
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = 'fallback', -- not recommended to change
    },
    -- Set up format-on-save
    -- format_on_save = { timeout_ms = 500 },
    -- If this is set, Conform will run the formatter asynchronously after save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_after_save = {
      lsp_format = 'fallback',
    },

    formatters_by_ft = {},
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
