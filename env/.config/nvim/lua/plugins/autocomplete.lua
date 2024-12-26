return {
  'saghen/blink.cmp',
  lazy = false,
  dependencies = 'rafamadriz/friendly-snippets',
  version = 'v0.*',
  -- ---@module 'blink.cmp'
  -- ---@type blink.cmp.Config
  -- opts = {
  --   keymap = { preset = 'super-tab' },
  --   highlight = {
  --     use_nvim_cmp_as_default = false,
  --   },
  --   nerd_font_variant = 'mono',
  --   accept = { auto_brackets = { enabled = true } },
  --   trigger = {
  --     show_in_snippet = false,
  --     signature_help = { enabled = true },
  --   },
  -- },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = { preset = 'super-tab' },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = false,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },
    completion = {
      -- 'prefix' will fuzzy match on the text before the cursor
      -- 'full' will fuzzy match on the text before *and* after the cursor
      -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      keyword = { range = 'full' },

      -- Disable auto brackets
      -- NOTE: some LSPs may add auto brackets themselves anyway
      accept = { auto_brackets = { enabled = false } },

      -- Insert completion item on selection, don't select by default
      list = { selection = 'auto_insert' },

      menu = {
        -- Don't automatically show the completion menu
        auto_show = true,

        -- nvim-cmp style menu
        draw = {
          columns = {
            { 'label', 'label_description', gap = 2 },
            { 'kind_icon', 'kind', gap = 2 },
          },
        },
      },

      -- Show documentation when selecting a completion item
      documentation = { auto_show = true, auto_show_delay_ms = 500 },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = false },
    },

    sources = {
      -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- Disable cmdline completions
      cmdline = {},
    },

    -- Experimental signature help support
    signature = { enabled = true },
  },
}
