-- Get the system appearance and set background color
local change_bg = function(bg)
  local background = (bg == 'dark' or bg == 'light') and bg or nil

  if not background and vim.fn.has 'mac' == 1 then
    local appearance = vim.fn.systemlist { 'defaults', 'read', '-g', 'AppleInterfaceStyle' }
    if vim.v.shell_error == 0 and appearance[1] == 'Dark' then
      background = 'dark'
    end
  end

  vim.opt.background = background or 'light'
end

-- Usage: --  :ChangeBg           -- auto-detect system appearance
--  :ChangeBg dark      -- force dark background
--  :ChangeBg light     -- force light background
-- or call from Lua:
--  require('your_module_name').change_bg()         -- auto-detect
--
vim.api.nvim_create_user_command('ChangeBg', change_bg, {
  desc = 'Change the editor appearance to match the system or a given value',
  nargs = '?',
  complete = function()
    return { 'dark', 'light' }
  end,
})

return {
  'catppuccin/nvim',
  lazy = false,
  priority = 1000,
  init = function()
    require('catppuccin').setup {
      integrations = {
        blink = true,
        diffview = true,
        mason = true,
        telekasten = true,
        which_key = true,
      },
    }
    change_bg()
    vim.cmd 'colorscheme catppuccin'
  end,
}
