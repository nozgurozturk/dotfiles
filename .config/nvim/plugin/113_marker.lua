local lazy = require("lazyload")

lazy.on_vim_enter(function ()
	vim.pack.add({ "https://github.com/nvim-mini/mini.visits" })

	require("mini.visits").setup()
end)
