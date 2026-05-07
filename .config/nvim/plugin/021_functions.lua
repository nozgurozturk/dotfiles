local gr = vim.api.nvim_create_augroup('custom-config', { clear = true })
Config.autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback(ev.data)
  end

  Config.autocmd('PackChanged', '*', f, desc)
end

local merge = require 'merge'
Config.add = function(spec)
  merge(_G.Config, spec)
end
