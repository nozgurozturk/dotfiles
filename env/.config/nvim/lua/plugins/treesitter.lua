return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		auto_install = true,
		highlight = { enable = true, additional_vim_regex_highlighting = { "ruby", "markdown" } },
		indent = { enable = true, disable = { "ruby" } },
		incremental_selection = { enable = false },
		textobjects = { enable = false },
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end
}
