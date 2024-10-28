return {
	{
		"David-Kunz/gen.nvim",
		opts = {
			model = "llama3.2:1b",
			quit_map = "q",
			retry_map = "<c-r>",
			accept_map = "<c-cr>",
			host = "localhost",
			port = "11434",
			display_mode = "float",
			show_prompt = false,
			show_model = false,
			no_auto_close = false,
			file = false,
			hidden = false,
			init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,

			command = function(options)
				local body = { model = options.model, stream = true }
				return "curl --silent --no-buffer -X POST http://" ..
					options.host .. ":" .. options.port .. "/api/chat -d $body"
			end,
			debug = false -- Prints errors and the command which is run.},
		},
		config = function(_, opts)
			local gen = require("gen")
			gen.setup(opts)

			gen.prompts["Review_Code"].model = "codegemma:2b"
			gen.prompts["Enhance_Code"].model = "codegemma:2b"
			gen.prompts["Change_Code"].model = "codegemma:2b"
		end
	},
	{
		'Exafunction/codeium.vim',
		event = 'BufEnter',
		config = function()
			vim.g.codeium_manual = true
			vim.g.codeium_no_map_tab = true

			vim.keymap.set('i', '<C-y>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
		end
	}
}
