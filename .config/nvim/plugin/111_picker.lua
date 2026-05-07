local lazy = require("lazyload")

lazy.on_vim_enter(function()
	vim.pack.add( { "https://github.com/nvim-mini/mini.pick" })

	local height = math.floor(0.618 * vim.o.lines)
    	local width = math.floor(0.618 * vim.o.columns)

	require('mini.pick').setup({
		options = {
        		use_cache = true,
      		},
      		window = {
        		config = {
				border = 'single',
				anchor = 'NW',
				height = height,
				width = width,
				row = math.floor(0.5 * (vim.o.lines - height)),
				col = math.floor(0.5 * (vim.o.columns - width)),
        		},
      		},

	})
end)
