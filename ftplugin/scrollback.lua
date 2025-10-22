Snacks.terminal.colorize()
vim.bo.modifiable = false
vim.o.laststatus = 0
vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = true })
vim.keymap.set("n", "i", "<cmd>q<CR>", { buffer = true })
