return {
  'hoob3rt/lualine.nvim',
  config = function()
    local lualine = require 'lualine'
    local comp = require 'lualine.component'

    local cp_comp = comp:extend()

    ---@alias CopilotRunningStatus string
    ---| 'running' # copilot is running
    ---| 'idle' # copilot is idle

    ---@class CopilotComponentOptions
    local default_options = {
      ---@class CopilotSymbols
      symbols = {
        enabled = ' ',
        disabled = ' ',
        running = ' ',
      },
      show_running = true,
    }


    ---Check if copilot is enabled
    ---@return boolean
    local function enabled()
      if vim.g.loaded_copilot == 1 and vim.fn['copilot#Enabled']() == 1 then
        return true
      else
        return false
      end
    end

    ---Show copilot running status
    ---@return CopilotRunningStatus
    local function running_status()
      local agent = vim.g.loaded_copilot == 1 and vim.fn['copilot#RunningAgent']() or nil
      if not agent or agent == vim.NIL then
        return 'idle'
      end
      -- most of the time, requests is just empty dict.
      local requests = agent.requests or {}

      -- requests is dict with number as index, get status from those requests.
      for _, req in pairs(requests) do
        local req_status = req.status
        if req_status == 'running' then
          return 'running'
        end
      end
      return 'idle'
    end

    -- Toggle copilot
    local function toggle()
      if enabled() then
        vim.b.copilot_enabled = 0
      else
        vim.b.copilot_enabled = nil
      end
    end

    ---Initialize component
    ---@param options CopilotComponentOptions
    function cp_comp:init(options)
      -- Setup click handler
      options.on_click = toggle

      cp_comp.super.init(self, options)
      ---@type CopilotComponentOptions
      self.options = vim.tbl_deep_extend('force', default_options, options or {})

      -- Setup options
      self.symbols = self.options.symbols
      self.show_running = self.options.show_running
    end

    function cp_comp:update_status()
      if enabled() then
        -- return symbols.enabled
        local status = self.show_running and running_status() or 'idle'
        if status == 'running' then
          return self.symbols.running
        end
        return self.symbols.enabled
      else
        return self.symbols.disabled
      end
    end

    lualine.setup({
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {}
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { {
          'filename',
          file_status = true,           -- displays file status (readonly status, modified status)
          path = 0                      -- 0 = just filename, 1 = relative path, 2 = absolute path
        } },
        lualine_x = {
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
          },
          cp_comp,
          'filetype'
        },
        lualine_y = { "require'lsp-status'.status()" },
        lualine_z = {}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { {
          'filename',
          file_status = true,           -- displays file status (readonly status, modified status)
          path = 1                      -- 0 = just filename, 1 = relative path, 2 = absolute path
        } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = { 'fugitive' }
    })
  end,
}
