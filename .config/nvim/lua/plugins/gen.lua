local function map(mode, lhs, rhs, opts)
  opts = opts or { noremap = true }
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      adapters = {
        acp = {
          gemini_cli = function()
            return require('codecompanion.adapters').extend('gemini_cli', {
              defaults = {
                auth_method = 'gemini-api-key', -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
              },
              schema = {
                model = 'gemini-3.1-pro-preview',
              },
              env = {
                GEMINI_API_KEY = os.getenv 'GEMINI_API_KEY',
              },
            })
          end,
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
          gemini = function()
            return require('codecompanion.adapters').extend('gemini', {
              schema = {
                model = {
                  default = 'gemini-3-flash-preview',
                },
              },
            })
          end,
        },
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
          -- adapter = 'gemini_cli',
        },
        inline = {
          adapter = 'anthropic',
          -- adapter = 'gemini',
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
  },
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
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
            accept = nil,
            accept_line = nil,
            accept_n_lines = nil,
            next = nil,
            prev = nil,
            dismiss = nil,
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
          gemini = {
            model = 'gemini-2.5-flash',
            stream = true,
            api_key = 'GEMINI_API_KEY',
            end_point = 'https://generativelanguage.googleapis.com/v1beta/models',
            optional = {
              generationConfig = {
                maxOutputTokens = 256,
                thinkingConfig = {
                  thinkingBudget = 0,
                },
              },
              safetySettings = {
                {
                  category = 'HARM_CATEGORY_DANGEROUS_CONTENT',
                  threshold = 'BLOCK_ONLY_HIGH',
                },
              },
            },
          },
        },
      }

      local virtualtext = require 'minuet.virtualtext'

      local function disable_virtualtext_autotrigger()
        vim.b.minuet_virtual_text_auto_trigger = false
      end

      map('i', '<A-\\>', function()
        disable_virtualtext_autotrigger()
        virtualtext.action.next()
      end, { desc = 'Minuet trigger completion' })

      map('i', '<C-y>', virtualtext.action.accept, { desc = 'Minuet accept completion' })
      map('i', '<A-e>', virtualtext.action.dismiss, { desc = 'Minuet dismiss completion' })
      map('i', '<A-]>', virtualtext.action.next, { desc = 'Minuet next suggestion' })
      map('i', '<A-[>', virtualtext.action.prev, { desc = 'Minuet previous suggestion' })

      local manual_trigger_group = vim.api.nvim_create_augroup('MinuetManualVirtualText', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
        group = manual_trigger_group,
        callback = disable_virtualtext_autotrigger,
      })
      disable_virtualtext_autotrigger()
    end,
  },
}
