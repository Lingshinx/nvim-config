local start = vim.fn.reltime()
local with_buf = require("utils.fn").start_with_buf()

-- require "utils.profiler"
require "config.globals"
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

    if with_buf then vim.api.nvim_exec_autocmds({ "BufEnter", "FileType" }, {}) end
  end,
})

if with_buf then
  vim.o.laststatus = 3
  require "config.options"
  wait()
else
  vim.api.nvim_create_autocmd("UIEnter", {
    callback = function() require "config.options" end,
  })

  vim.o.laststatus = 0
  vim.api.nvim_create_autocmd("User", {
    pattern = "SnacksDashboardClosed",
    callback = function() vim.o.laststatus = 3 end,
  })
end

vim.g.config_startuptime = vim.fn.reltimefloat(vim.fn.reltime(start)) * 1000
