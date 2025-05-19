-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "dm", "<cmd>delm!<CR>")
vim.keymap.set("n", "<CR>", "a<CR><Esc>")
vim.keymap.set("n", "<S-CR>", "i<CR><Esc>")
vim.keymap.set("n", "<UP>", "<C-u>")
vim.keymap.set("n", "<Down>", "<C-d>")
vim.keymap.set("n", "<Left>", "<Home>")
vim.keymap.set("n", "<Right>", "<End>")
vim.keymap.set("n", "<Leader>n", function()
  Snacks.notifier.show_history()
end)
vim.keymap.set("n", "<Leader>fh", "<cmd>Telescope hoogle hoogle<CR>")
vim.keymap.set("n", "<BS>", "@@")
vim.keymap.set("n", "<leader>ch", "<cmd>cd %:h<CR>")

vim.keymap.set("i", "jk", "<Esc>", { desc = "which_key_ignore" })
vim.keymap.set("i", "<C-CR>", "<End><CR>")
vim.keymap.set({ "i", "c" }, "<C-S-V>", '<C-r>"')
vim.keymap.set({ "i", "c" }, "<S-Insert>", '<C-r>"')
vim.keymap.set({ "i", "c" }, "<C-BS>", "<C-w>")

vim.keymap.set("t", "<C-S-V>", "<cmd>stopinsert<CR>pi")
vim.keymap.set("t", "<esc><esc>", "<cmd>stopinsert<CR>", { desc = "which_key_ignore" })
