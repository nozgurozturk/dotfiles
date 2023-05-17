function SetColor()
    require 'github-theme'.setup({
        theme_style = "dark",
    })

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetColor()
