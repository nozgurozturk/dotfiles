require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

function R(name)
	require("plenary.reload").reload_module(name)
end
