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
      {
        'Davidyz/VectorCode',
        version = '*',
        build = 'uv tool upgrade vectorcode',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    opts = {
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = 'Prompt ', -- Prompt used for interactive LLM calls
          provider = 'mini_pick', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            title = 'CodeCompanion actions', -- The title of the action palette
          },
        },
      },
      memory = {
        opts = {
          chat = {
            ---Function to determine if memory should be added to a chat buffer
            ---This requires `enabled` to be true
            ---@param chat CodeCompanion.Chat
            ---@return boolean
            condition = function(chat)
              return chat.adapter.type ~= 'acp'
            end,
          },
        },
      },
      adapters = {
        acp = {
          codex = function()
            return require('codecompanion.adapters').extend('codex', {
              defaults = {
                auth_method = 'chatgpt', -- "openai-api-key"|"codex-api-key"|"chatgpt"
              },
              commands = {
                default = {
                  'pnpx',
                  '--silent',
                  '@zed-industries/codex-acp',
                },
              },
            })
          end,
        },
        http = {
          gemini = function()
            return require('codecompanion.adapters').extend('gemini', {
              schema = {
                model = {
                  default = 'gemini-2.5-pro',
                },
              },
            })
          end,
        },
      },
      ---@module "vectorcode"
      extensions = {
        vectorcode = {
          ---@type VectorCode.CodeCompanion.ExtensionOpts
          opts = {
            tool_group = {
              -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
              enabled = true,
              -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
              -- if you use @vectorcode_vectorise, it'll be very handy to include
              -- `file_search` here.
              extras = {},
              collapse = false, -- whether the individual tools should be shown in the chat
            },
            tool_opts = {
              ---@type VectorCode.CodeCompanion.ToolOpts
              ['*'] = {},
              ---@type VectorCode.CodeCompanion.LsToolOpts
              ls = {},
              ---@type VectorCode.CodeCompanion.VectoriseToolOpts
              vectorise = {},
              ---@type VectorCode.CodeCompanion.QueryToolOpts
              query = {
                max_num = { chunk = -1, document = -1 },
                default_num = { chunk = 50, document = 10 },
                include_stderr = false,
                use_lsp = false,
                no_duplicate = true,
                chunk_mode = false,
                ---@type VectorCode.CodeCompanion.SummariseOpts
                summarise = {
                  ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                  enabled = false,
                  adapter = nil,
                  query_augmented = true,
                },
              },
              files_ls = {},
              files_rm = {},
            },
          },
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
      strategies = {
        chat = {
          adapter = 'codex',
        },
        inline = {
          adapter = 'openai',
          keymaps = {
            accept_change = {
              modes = { n = '<C-y>' },
              description = 'Accept the suggested change',
            },
            reject_change = {
              modes = { n = '<C-c>' },
              description = 'Reject the suggested change',
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
          enabled_ft = {},
          disabled_ft = {},
          enabled_auto_trigger_ft = {},
          disabled_auto_trigger_ft = {},
          warn_on_blink_or_cmp = true,
          adjust_indentation = true,
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
        provider = 'openai',
        provider_options = {
          openai = {
            model = 'gpt-5-mini',
            end_point = 'https://api.openai.com/v1/chat/completions',
            stream = true,
            api_key = 'OPENAI_API_KEY',
            optional = {
              max_completion_tokens = 256,
              reasoning_effort = 'minimal',
              n = 1,
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
