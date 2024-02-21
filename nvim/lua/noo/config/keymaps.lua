vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", vim.cmd.Rex) -- open explorer

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move line down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move line up

vim.keymap.set("n", "J", "mzJ`z") -- join line
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- scroll down
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- scroll up
vim.keymap.set("n", "n", "nzzzv") -- keep cursor centered
vim.keymap.set("n", "N", "Nzzzv") -- keep cursor centered


vim.keymap.set("x", "<leader>p", [["_dP]]) -- paste without overwriting the default register

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- copy to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])          -- copy to system clipboard

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]]) -- cut without overwriting the default register

vim.keymap.set("n", "Q", "<nop>") -- disable Ex mode
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmuxs<CR>") -- open tmux session
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format) -- format code

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz") 
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- search and replace word under cursor
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })              -- make exewcutable

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
