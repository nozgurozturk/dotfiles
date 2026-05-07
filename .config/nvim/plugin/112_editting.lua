local lazy = require("lazyload")

lazy.on_vim_enter(function ()
	vim.pack.add({ "https://github.com/nvim-mini/mini.surround" })

	require("mini.surround").setup()
end)
