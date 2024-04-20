require("noo.config.options")
require("noo.config.keymaps")
require("noo.config.autocmds")
require("noo.config.lazy")

function R(name)
  require("plenary.reload").reload_module(name)
end

vim.filetype.add({
  extension = {
    templ = 'templ',
  }
})

vim.g.netrw_browse_split = 0
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3


-- Get the system appearance and set background color
local system_appearance = vim.fn.system('defaults read -g AppleInterfaceStyle')
if system_appearance == 'Dark\n' then
  vim.opt.background = 'dark'
else
  vim.opt.background = 'light'
end
