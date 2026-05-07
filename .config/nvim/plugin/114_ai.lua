require('lazyload').on_vim_enter(function()
  vim.pack.add {

    { src = 'https://www.github.com/nvim-lua/plenary.nvim' },
    {
      src = 'https://www.github.com/olimorris/codecompanion.nvim',
      version = vim.version.range '^19.0.0',
    },
    { src = 'https://github.com/milanglacier/minuet-ai.nvim' },
  }

  require('codecompanion').setup {
    adapters = {
      acp = {
        claude_code = function()
          return require('codecompanion.adapters').extend('claude_code', {
            env = {
              CLAUDE_CODE_OAUTH_TOKEN = os.getenv 'CLAUDE_CODE_OAUTH_TOKEN',
            },
            commands = {
              default = {
                'pnpx',
                '--silent',
                '@zed-industries/claude-agent-acp',
              },
            },
          })
        end,
      },
      http = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            schema = {
              model = {
                default = 'claude-sonnet-4-6',
              },
            },
          })
        end,
      },
      prompt_library = {
        ['Fix grammer and typos'] = {
          strategy = 'inline',
          description = 'Fix grammar and typos in the selected text',
          prompts = {
            {
              role = 'system',
              content = '[[You are a helpful assistant that fixes grammar and typos, and then enhances the wording in English.]]',
            },
            {
              role = 'user',
              content = 'Fix grammer and typos, and then enhance the wording.',
            },
          },
        },
      },
      interactions = {
        chat = {
          adapter = 'claude_code',
        },
        inline = {
          adapter = 'anthropic',
          keymaps = {
            accept_change = {
              callback = 'keymaps.accept_change',
              description = 'Accept the suggested change',
              modes = { n = '<C-y>' },
              index = 2,
              opts = { nowait = true, noremap = true },
            },
            reject_change = {
              callback = 'keymaps.reject_change',
              description = 'Reject the suggested change',
              modes = { n = '<C-c>' },
              index = 3,
              opts = { nowait = true, noremap = true },
            },
          },
        },
      },
    },
  }

  require('minuet').setup {
    cmp = { enable_auto_complete = false },
    blink = { enable_auto_complete = false },
    lsp = {
      completion = {
        enabled_ft = {},
        disabled_ft = {},
        enabled_auto_trigger_ft = {},
        disabled_auto_trigger_ft = {},
        warn_on_blink_or_cmp = true,
        adjust_indentation = true,
      },
    },
    virtualtext = {
      auto_trigger_ft = {},
      auto_trigger_ignore_ft = { '*' },
      keymap = {
        accept = '<C-y>',
        accept_line = nil,
        accept_n_lines = nil,
        next = '<A-[>',
        prev = '<A-]>',
        dismiss = '<C-c>',
      },
      show_on_completion_menu = false,
    },
    notify = 'error',
    provider = 'claude',
    provider_options = {
      provider_options = {
        claude = {
          max_tokens = 256,
          model = 'claude-haiku-4.5',
          system = 'see [Prompt] section for the default value',
          few_shots = 'see [Prompt] section for the default value',
          chat_input = 'See [Prompt Section for default value]',
          stream = true,
          api_key = 'ANTHROPIC_API_KEY',
          end_point = 'https://api.anthropic.com/v1/messages',
          optional = {
            -- pass any additional parameters you want to send to claude request,
            -- e.g.
            -- stop_sequences = nil,
          },
          -- a list of functions to transform the endpoint, header, and request body
          transform = {},
        },
      },
    },
  }

  vim.b.minuet_virtual_text_auto_trigger = false

  Config.autocmd({ 'BufEnter', 'InsertLeave' }, '*', function()
    vim.b.minuet_virtual_text_auto_trigger = false
  end, 'Disable ai autocomplete')
end)
