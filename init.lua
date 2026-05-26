-- require "utils.profiler"
require "config.options"
require "load.workspace"
pcall(require, "config.custom")
local wait = require "load.packs"
local langs = require "load.langs"
require "load.colorscheme"

vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  callback = function()
    langs:load()
    require "load.keymap"
    require "config.autocmds"
    require "load.after"
    require "config.neovide"

    if vim.fn.argc(-1) ~= 0 then vim.api.nvim_exec_autocmds("BufEnter", {}) end
  end,
})

wait()
