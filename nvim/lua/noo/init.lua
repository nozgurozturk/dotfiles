require("noo.config.options")
require("noo.config.keymaps")
require("noo.config.autocmds")
require("noo.config.lazy")

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

-- Get the system appearance and set background color
local system_appearance = vim.fn.system("defaults read -g AppleInterfaceStyle")
if system_appearance == "Dark\n" then
	vim.opt.background = "dark"
else
	vim.opt.background = "light"
end
