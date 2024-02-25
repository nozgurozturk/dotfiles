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

vim.g.netrw_banner = 0       -- disable banner
vim.g.netrw_browse_split = 0 -- open in same window
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
vim.g.netrw_liststyle = 3
