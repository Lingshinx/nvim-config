require("config.keymaps.git")
require("config.keymaps.file")
require("config.keymaps.search")
require("config.keymaps.toggle")
require("config.keymaps.winbuf")
require("config.keymaps.lsp")
require("config.keymaps.delete")

local map = vim.keymap.set

map("n", "dm", "<cmd>delm!<CR>", { desc = "Delete Marks" })
map("n", "<UP>", "<C-u>")
map("n", "<Down>", "<C-d>")
map("n", "<Left>", "<C-f>")
map("n", "<Right>", "<C-b>")
map("n", "#", [[:%s/\<<C-r><C-w>\>/]], { desc = "Replace" })

map("i", "<C-CR>", "<End><CR>")
map({ "i", "c" }, "<C-S-V>", '<C-r>"')
map({ "i", "c" }, "<S-Insert>", '<C-r>"')
map({ "i", "c" }, "<C-BS>", "<C-w>")
-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

map("t", "<C-S-V>", "<cmd>stopinsert<CR>pi", { desc = "paste" })
map("t", "<S-Insert>", "<cmd>stopinsert<CR>pi", { desc = "paste" })
map("t", "<esc><esc>", "<cmd>stopinsert<CR>", { desc = "which_key_ignore" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw/Update" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

map("n", "<leader>n", Snacks.notifier.show_history, { desc = "Notifications" })
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Notifications" })

require("which-key").add({ "<leader>K", "<cmd>norm! K<cr>", desc = "Keyword", icon = "" })
