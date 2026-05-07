local lazy = require("lazyload")

lazy.on_vim_enter(function()
  local ts_update = function() vim.cmd("TSUpdate") end
  Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

  vim.pack.add({
	  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = "main" },
	  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  })

  local languages = Config.treesitter.ensure_installed
  local not_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end
  local to_install = vim.tbl_filter(not_installed, languages)
  if #to_install > 0 then require("nvim-treesitter").install(to_install) end

  -- Ensure Neovim detects .ejs files correctly
  vim.filetype.add({ extension = { ejs = "ejs" } })
  vim.treesitter.language.register("embedded_template", "ejs")

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  Config.autocmd("FileType", filetypes, ts_start, "Start tree-sitter")

  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      selection_modes = {
        ["@parameter.outer"] = "v",
        ["@function.outer"] = "v",
        ["@class.outer"] = "<c-v>",
      },
      include_surrounding_whitespace = false,
    },
  })
end)
