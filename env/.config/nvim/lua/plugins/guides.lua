return {
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
		opts = {
			max_count = 3,
			allow_different_key = true,
			hints = {
				["[dcyvV][ia][%(%)]"] = {
					message = function(keys)
						return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
					end,
					length = 3,
				},
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	}
}
