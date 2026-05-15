if vim.secure.read "./.nvim" ~= true then return end

vim.cmd([[set rtp+=]] .. vim.fs.abspath ".nvim")

pcall(dofile, "./.nvim/init.lua")
