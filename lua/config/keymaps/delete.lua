local del = vim.keymap.del
local map = vim.keymap.set

del("n", "grn")
del("n", "gra")
del("n", "grr")
del("n", "gri")
del("n", "grt")

map({ "n", "x", "o" }, "s", "gs", { remap = true })
